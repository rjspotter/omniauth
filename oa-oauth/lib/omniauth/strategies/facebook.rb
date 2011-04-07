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
        options[:scope] ||= "email,user_birthday"
        super(app, :facebook, consumer_store, {:site => 'https://graph.facebook.com/'}, options, &block)
      end
      
      def user_data
        @data ||= MultiJson.decode(@access_token.get('/me', {}, { "Accept-Language" => "en-us,en;"}))
      end
      
      def user_info
        {
          'nickname'   => user_data["link"].split('/').last,
          'first_name' => user_data["first_name"],
          'last_name'  => user_data["last_name"],
          'gender'     => user_data['gender'].to_s.first.upcase,
          'dob'        => user_data['birthday_date'],
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
