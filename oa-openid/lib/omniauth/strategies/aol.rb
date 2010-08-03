require 'omniauth/openid'

module OmniAuth
  module Strategies
    class Aol < OmniAuth::Strategies::OpenID
      def identifier; 'http://openid.aol.com/' end
    end
  end
end
