require 'omniauth/openid'

module OmniAuth
  module Strategies
    class Yahoo < OmniAuth::Strategies::OpenID
      def identifier; 'https://yahoo.com/' end
    end
  end
end
