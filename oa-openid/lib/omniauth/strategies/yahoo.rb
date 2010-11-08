require 'omniauth/openid'

module OmniAuth
  module Strategies
    class Yahoo < OmniAuth::Strategies::OpenID
      def identifier; 'https://yahoo.com/' end
      def initialize(app,store,options = {})
        options[:required] = ['nickname','fullname','email','dob','gender','timezone','language','country','postcode']
        options[:optional] = []
        super(app,store,options)
      end
    end
  end
end
