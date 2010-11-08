require 'omniauth/openid'

module OmniAuth
  module Strategies
    class Google < OmniAuth::Strategies::OpenID
      def initialize(app,store,options = {})
        options[:required] = [AX[:email], AX[:first_name], AX[:last_name], AX[:nickname]]
        options[:optional] = [AX[:city], AX[:state], AX[:website], AX[:image]]
        super(app,store,options)
      end
      def identifier; 'https://www.google.com/accounts/o8/id' end
    end
  end
end
