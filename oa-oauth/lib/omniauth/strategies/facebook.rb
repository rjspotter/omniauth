require 'omniauth/oauth'
require 'multi_json'
require 'chronic'

module OmniAuth
  module Strategies
    #
    # Authenticate to Facebook utilizing OAuth 2.0 and retrieve
    # basic user information.
    #
    # Usage:
    #
    #    use OmniAuth::Strategies::Facebook, 'app_id', 'app_secret'
    #
    # Options:
    #
    # <tt>:scope</tt> :: Extended permissions such as <tt>email</tt> and <tt>offline_access</tt> (which are the defaults).
    class Facebook < OAuth2
      def initialize(app, app_id, app_secret, options = {})
        options[:site] = 'https://graph.facebook.com/'
        super(app, :facebook, app_id, app_secret, options)
      end
      
      def user_data
        @data ||= MultiJson.decode(@access_token.get('/me'))
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
