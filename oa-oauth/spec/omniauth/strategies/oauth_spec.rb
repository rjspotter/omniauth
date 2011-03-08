require 'spec_helper'

describe "OmniAuth::Strategies::OAuth" do

  def app
    store = double()
    store.stub(:key) do |arg|
      if arg == :thingone
        "abc"
      else
        "someotherthingy"
      end
    end
    store.stub(:secret) do |arg|
      if arg == :thingone
        "def"
      else
        "someotherthingy"
      end
    end
    Rack::Builder.new {
      use OmniAuth::Test::PhonySession
      use OmniAuth::Builder do
        provider :oauth, 'example.org', store, :site => 'https://api.example.org'
      end
      run lambda { |env| [404, {'Content-Type' => 'text/plain'}, [env.key?('omniauth.auth').to_s]] }
    }.to_app
  end

  def session
    last_request.env['rack.session']
  end

  before do
    stub_request(:post, 'https://api.example.org/oauth/request_token').
      to_return(:body => 
                 "oauth_token=yourtoken&oauth_token_secret=yoursecret&oauth_callback_confirmed=true")
    
  end

  describe '/auth/{name}' do
    before do
      get '/auth/example.org'
    end

    it 'should send a request for a request_token' do
      WebMock.should have_requested(:post, 'https://api.example.org/oauth/request_token')
    end

    it 'should send the right api key' do
      WebMock.should have_requested(:post, 'https://api.example.org/oauth/request_token').
        with(:headers => {'Authorization' => /someotherthing/})
    end

    it 'should redirect to authorize_url' do
      last_response.should be_redirect
      last_response.headers['Location'].should == 'https://api.example.org/oauth/authorize?oauth_token=yourtoken'
    end

    it 'should set appropriate session variables' do
      session['oauth'].should == {"example.org" => {
          'callback_confirmed' => true, 
          'request_token' => 'yourtoken', 
          'request_secret' => 'yoursecret'
        }}
    end
  end

  describe '/auth/{name}?consumer=thingone' do
  
    it 'should send the right api key' do
      get '/auth/example.org?consumer=thingone'
      WebMock.should have_requested(:post, 'https://api.example.org/oauth/request_token').
        with(:headers => {'Authorization' => /abc/})
    end

  end

  describe '/auth/{name}/callback' do
    before do
      stub_request(:post, 'https://api.example.org/oauth/access_token').
         with(:headers => {'Authorization' => /someotherthing/}).
         to_return(:body => "oauth_token=yourtoken&oauth_token_secret=yoursecret")
      get '/auth/example.org/callback', {:oauth_verifier => 'dudeman'}, {'rack.session' => {
          'oauth' => {
            "example.org" => {
              'callback_confirmed' => true, 
              'request_token' => 'yourtoken', 
              'request_secret' => 'yoursecret'
            }}}}
    end

    it 'should exchange the request token for an access token' do
      last_request.env['omniauth.auth']['provider'].should == 'example.org'
      last_request.env['omniauth.auth']['extra']['access_token'].should be_kind_of(OAuth::AccessToken)
    end

    it 'should call through to the master app' do
      last_response.body.should == 'true'
    end

    context "bad gateway (or any 5xx) for access_token" do
      before do
        stub_request(:post, 'https://api.example.org/oauth/access_token').
           to_raise(::Net::HTTPFatalError.new(%Q{502 "Bad Gateway"}, nil))
        get '/auth/example.org/callback', {:oauth_verifier => 'dudeman'}, {'rack.session' => {
            'oauth' => {
              "example.org" => {
                'callback_confirmed' => true, 
                'request_token' => 'yourtoken', 
                'request_secret' => 'yoursecret'
              }}}}
      end

      it 'should call fail! with :service_unavailable' do
        last_request.env['omniauth.error'].should be_kind_of(::Net::HTTPFatalError)
        last_request.env['omniauth.error.type'] = :service_unavailable
      end
    end
  end
end
