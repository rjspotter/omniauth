require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "OmniAuth::Strategies::OAuthWrap" do
  
  def app
    Rack::Builder.new {
      use OmniAuth::Test::PhonySession
      use OmniAuth::Builder do
        provider OmniAuth::Strategies::OAuthWrap, 'example.org', 'abc', 'def', {
          :site              => 'https://api.example.org',
          :verify_path       => '/oauth/wrap.ext',
          :access_token_path => '/oauth/access_token.ext'
        }
      end
      run lambda { |env| [200, {'Content-Type' => 'text/plain'}, [Rack::Request.new(env).params.key?('auth').to_s]] }
    }.to_app
  end

  def session
    last_request.env['rack.session']
  end
  
  # before do
  #   stub_request(:post, 'https://api.example.org/oauth/request_token').
  #     to_return(:body => "oauth_token=yourtoken&oauth_token_secret=yoursecret&oauth_callback_confirmed=true")
  # end
  
  describe '/auth/{name}' do
    before do
      get '/auth/example.org'
    end

    it 'should redirect to authorize_url' do
      last_response.should be_redirect
      last_response.headers['Location'].should == 
        'https://api.example.org/oauth/wrap.ext?wrap_client_id=abc&wrap_callback=http://example.org/auth/example.org/callback'
    end
  
    # it 'should set appropriate session variables' do
    # end
  end
  
  describe '/auth/{name}/callback' do
    before do
      stub_request(:post, 'https://api.example.org/oauth/access_token.ext').
      to_return(:body => "wrap_access_token=asdf&wrap_access_token_expires_in=60&wrap_refresh_token=qwerty&uid=madhatter")
      # WebMock.after_request do |request_signature, response|
      #   puts "Request #{request_signature} was made and #{response} was returned"
      # end
      get '/auth/example.org/callback?wrap_verification_code=placeholder'
    end

    it 'should call access_token url' do
      WebMock.should have_requested(:post, 'https://api.example.org/oauth/access_token.ext')
    end


    it 'should pass wrap_verification code from parameters' do
      WebMock.should have_requested(:post, 'https://api.example.org/oauth/access_token.ext').with {|req| req.body["wrap_verification_code=placeholder"]}
    end    

    it 'should pass client_id abc' do
      WebMock.should have_requested(:post, 'https://api.example.org/oauth/access_token.ext').with {|req| req.body["wrap_client_id=abc"]}
    end

    it 'should pass client_secret' do
      WebMock.should have_requested(:post, 'https://api.example.org/oauth/access_token.ext').with {|req| req.body["wrap_client_secret=def"]}
    end

    it 'should pass callback url' do
      WebMock.should have_requested(:post, 'https://api.example.org/oauth/access_token.ext').with do |req| 
        req.body["wrap_callback=http://www.example.org/auth/example.org/callback"]
      end
    end
    
    # it 'should call through to the master app' do
    #   last_response.body.should == 'true'
    # end

  end

end
