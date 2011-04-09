require 'multi_json'
require 'oauth'
require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class OAuth
      include OmniAuth::Strategy

      def initialize(app, name, consumer_store = nil, consumer_options = {}, options = {}, &block)
        self.consumer_store = consumer_store
        self.consumer_options = consumer_options.merge(options[:client_options] || options[:consumer_options] || {})
        super
        self.options[:open_timeout] ||= 30
        self.options[:read_timeout] ||= 30
        self.options[:authorize_params] = options[:authorize_params] || {}
      end

      def consumer(id)
        consumer = ::OAuth::Consumer.new(
                              consumer_key(id), 
                              consumer_secret(id), 
                              consumer_options)
		consumer.http.open_timeout = options[:open_timeout] if options[:open_timeout]
        consumer.http.read_timeout = options[:read_timeout] if options[:read_timeout]
        consumer
      end

      def consumer_key(id)
        consumer_store.key(id)
      end

      def consumer_secret(id)
        consumer_store.secret(id)
      end

      attr_reader :name
      attr_accessor :consumer_store, :consumer_options

      def request_phase
        request_token = consumer(consumer_id).get_request_token(:oauth_callback => callback_url)
        (session['oauth']||={})[name.to_s] = {'callback_confirmed' => request_token.callback_confirmed?, 'request_token' => request_token.token, 'request_secret' => request_token.secret}
        r = Rack::Response.new

        if request_token.callback_confirmed?
          r.redirect(request_token.authorize_url(options[:authorize_params]))
        else
          r.redirect(request_token.authorize_url(options[:authorize_params].merge(:oauth_callback => callback_url)))
        end

        r.finish
      rescue ::Timeout::Error => e
        fail!(:timeout, e)
      end

      def callback_phase
        request_token = ::OAuth::RequestToken.new(consumer(consumer_id), session['oauth'][name.to_s].delete('request_token'), session['oauth'][name.to_s].delete('request_secret'))

        opts = {}
        if session['oauth'][name.to_s]['callback_confirmed']
          opts[:oauth_verifier] = request['oauth_verifier']
        else
          opts[:oauth_callback] = callback_url
        end

        @access_token = request_token.get_access_token(opts)
        super
      rescue ::Timeout::Error => e
        fail!(:timeout, e)
      rescue ::Net::HTTPFatalError => e
        fail!(:service_unavailable, e)
      rescue ::OAuth::Unauthorized => e
        fail!(:invalid_credentials, e)
      rescue ::MultiJson::DecodeError => e
        fail!(:invalid_response, e)
      end

      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'credentials' => {
            'token' => @access_token.token,
            'secret' => @access_token.secret
          }, 'extra' => {
            'access_token' => @access_token
          }
        })
      end

      def unique_id
        nil
      end
    end
  end
end
