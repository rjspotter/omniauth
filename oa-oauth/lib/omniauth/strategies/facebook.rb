require 'omniauth/oauth'
require 'multi_json'
require 'chronic'

module OmniAuth
  module Strategies
    # Authenticate to Facebook utilizing OAuth 2.0 and retrieve
    # basic user information.
    #
    # @example Basic Usage
    #   use OmniAuth::Strategies::Facebook, Storage
    class Facebook < OAuth2
      # @param [Rack Application] app standard middleware application parameter
      # @option options [String] :scope ('email,offline_access') comma-separated extended permissions such as `email` and `manage_pages`
      def initialize(app, consumer_store = nil, options = {}, &block)
        super(app, :facebook, consumer_store, {:site => 'https://graph.facebook.com/'}, options, &block)
      end

       def user_data
        @data ||= MultiJson.decode(@access_token.get('/me', {}, { "Accept-Language" => "en-us,en;"}))
      end
      
      def request_phase
        options[:scope] ||= "email,offline_access"
        super
      end
      
      def build_access_token
        if facebook_session.nil? || facebook_session.empty?
          super
        else
          @access_token = ::OAuth2::AccessToken.new(client, facebook_session['access_token'])
        end
      end

      def facebook_session
        session_cookie = request.cookies["fbs_#{client.id}"]
        if session_cookie
          @facebook_session ||= Rack::Utils.parse_query(request.cookies["fbs_#{client.id}"].gsub('"', ''))
        else
          nil
        end
      end

      def user_info
        {
          'nickname' => user_data["link"].split('/').last,
          'email' => (user_data["email"] if user_data["email"]),
          'first_name' => user_data["first_name"],
          'last_name' => user_data["last_name"],
          'name' => "#{user_data['first_name']} #{user_data['last_name']}",
          'image' => "http://graph.facebook.com/#{user_data['id']}/picture?type=square",
          'urls' => {
            'Facebook' => user_data["link"],
            'Website' => user_data["website"],
          }
        }
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'uid' => user_data['id'],
          'user_info' => user_info,
          'extra' => {'user_hash' => user_data}
        })
      end
    end
  end
end
