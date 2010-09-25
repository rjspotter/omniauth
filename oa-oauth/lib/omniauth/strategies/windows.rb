require 'omniauth/oauth'

module OmniAuth
  module Strategies
    class Windows < OmniAuth::Strategies::OAuthWrap
      def initialize(app, consumer_key, consumer_secret)
        super(app, :windows, consumer_key, consumer_secret,{
          :site              => 'https://consent.live.com/',
          :verify_path       => '/Connect.aspx',
          :access_token_path => '/AccessToken.aspx'
        })
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, { })
      end

    end
  end
end
