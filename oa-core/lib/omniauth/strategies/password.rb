require 'digest/sha1'
require 'omniauth/core'

module OmniAuth
  module Strategies
    class Password
      include OmniAuth::Strategy
      
      def initialize(app, options = {})
        @options = options
        super(app, :password)
      end
      
      def request_phase
        return fail!(:missing_information) unless request[:identifier] && request[:password]
        return fail!(:password_mismatch) if request[:password_confirmation] && request[:password_confirmation] != '' && request[:password] != request[:password_confirmation]
        env['REQUEST_METHOD'] = 'GET'
        env['PATH_INFO'] = request.path + '/callback'
        request['auth'] = auth_hash(encrypt(request[:password]))
        @app.call(env)
      end
      
      def auth_hash(crypted_password)
        OmniAuth::Utils.deep_merge(super(), {
          'uid' => "#{request[:identifier]}::#{crypted_password}",
          'user_info' => {
            @options[:identifier_key] => request[:identifier]
          }
        })
      end
      
      def callback_phase
        @app.call(env)
      end
      
      def encrypt(password)
        Digest::SHA1.hexdigest(password)
      end
    end
  end
end
