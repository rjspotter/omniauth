require 'omniauth/openid'

module OmniAuth
  module Strategies
    class Aol < OmniAuth::Strategies::OpenID
      def identifier; 'http://openid.aol.com/' end
      def initialize(app,store,options = {})
        options[:required] = ["http://axschema.org/contact/email", "http://axschema.org/namePerson", "http://axschema.org/namePerson/first", "http://axschema.org/namePerson/last", "email", "fullname", "http://axschema.org/namePerson/friendly", "http://axschema.org/contact/city/home", "http://axschema.org/contact/state/home", "http://axschema.org/contact/web/default", "http://axschema.org/media/image/aspect11", "postcode", "nickname"]
        options[:optional] = []
        super(app,store,options)
      end
    end
  end
end
