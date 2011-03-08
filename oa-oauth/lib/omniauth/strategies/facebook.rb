require 'omniauth/oauth'
require 'multi_json'
require 'chronic'

module OmniAuth
  module Strategies
    # Authenticate to Facebook utilizing OAuth 2.0 and retrieve
    # basic user information.
    #
    # @example Basic Usage
    #   use OmniAuth::Strategies::Facebook, 'client_id', 'client_secret'
    class Facebook < OAuth2
      # @param [Rack Application] app standard middleware application parameter
      # @param [String] client_id the application id as [registered on Facebook](http://www.facebook.com/developers/)
      # @param [String] client_secret the application secret as registered on Facebook
      # @option options [String] :scope ('email,offline_access') comma-separated extended permissions such as `email` and `manage_pages`
      def initialize(app, consumer_store = nil, options = {}, &block)
        super(app, :facebook, consumer_store, {:site => 'https://graph.facebook.com/'}, options, &block)
      end
      
      def user_data
        @data ||= MultiJson.decode(@access_token.get('/me', {}, { "Accept-Language" => "en-us,en;"}))
      end
      
      def request_phase(options = {})
        options[:scope] ||= "email,offline_access,user_birthday"
        super(options)
      end
      
      def user_info
        {
          'nickname'   => user_data["link"].split('/').last,
          'first_name' => user_data["first_name"],
          'last_name'  => user_data["last_name"],
          'gender'     => user_data['gender'].to_s.first.upcase,
#           'dob'        => user_data['birthday_date'],
          'dob'        => user_data['birthday'] ? Chronic.parse(user_data['birthday']).strftime("%Y-%m-%d") : nil,
          'timezone'   => user_data['timezone'],
          'language'   => user_data['locale'],
          'email'      => user_data['email'],
          'name'       => user_data['name'] || "#{user_data['first_name']} #{user_data['last_name']}",
          'urls'       => {
            'Facebook' => user_data["link"],
            'Website'  => user_data["website"],
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
