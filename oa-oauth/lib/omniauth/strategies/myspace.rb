require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    #
    # Authenticate to Myspace utilizing OAuth 1.0 and retrieve
    # basic user information.
    #
    # Usage:
    #
    #    use OmniAuth::Strategies::Myspace, 'app_id', 'app_secret'
    #
    # Options:
    #
    class Myspace < OAuth
      def initialize(app, app_id, app_secret, options = {})
        options.merge!({
          :site => 'http://api.myspace.com',
          :http_method => :get,
          :scheme => :query_string,
          :request_token_path => '/request_token',
          :access_token_path => '/access_token',
          :authorize_path => '/authorize',
          :exclude_body_hash => true
        })
        super(app, :myspace, app_id, app_secret, options)
      end
      
      def user_data
        @data ||= MultiJson.decode(@access_token.get('/v1/user.json').body)
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
                                     'uid' => user_data['userId']
                                   })
      end
    end
  end
end
