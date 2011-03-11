require 'spec_helper'

describe "OmniAuth::Strategies::OAuth2" do


  def app
    store = double()
    store.stub(:key) do |arg|
      if arg == "thisisan-exam-ple0-uuid-fortesting00"
        "abc"
      else
        "someotherthingy"
      end
    end
    store.stub(:secret) do |arg|
      if arg == "thisisan-exam-ple0-uuid-fortesting00"
        "def"
      else
        "someotherthingy"
      end
    end
    Rack::Builder.new {
      use OmniAuth::Test::PhonySession
      use OmniAuth::Builder do
        provider :oauth2, 'example.org', store, :site => 'https://api.example.org'
      end
      run lambda { |env| [404, {'Content-Type' => 'text/plain'}, [env.key?('omniauth.auth').to_s]] }
    }.to_app
  end

  def session
    last_request.env['rack.session']
  end

  before do
    stub_request(:get, 'https://api.example.org/oauth/authorize').
      to_return(:body => 
                 "oauth_token=yourtoken&oauth_token_secret=yoursecret&oauth_callback_confirmed=true")
    
  end

  describe '/auth/{name}' do

    before do
      get '/auth/thisisan-exam-ple0-uuid-fortesting00/example.org'
    end

    it 'should redirect' do
      last_response.should be_redirect
    end

  end

end
