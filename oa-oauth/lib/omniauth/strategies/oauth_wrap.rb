require 'omniauth/oauth'
require 'rubygems'
require 'rack/client'
require 'cgi'

module OmniAuth
  module Strategies
    class OAuthWrap
      include OmniAuth::Strategy
      
      # :site => 'the endpoint base url'
      # :verify_path => 'path to redirect to'
      # :access_token_path => 'the access token path'
      #
      def initialize(app, name, consumer_store = nil, options = {})
        self.consumer_store, self.consumer_options = consumer_store, options
        super
      end

      attr_accessor :consumer_store, :consumer_options

      def consumer_key(id)
        consumer_store.key(id)
      end

      def consumer_secret(id)
        consumer_store.secret(id)
      end
    
      def request_phase
        r = Rack::Response.new
        r.redirect "#{URI.join(consumer_options[:site], consumer_options[:verify_path])}?wrap_client_id=#{consumer_key(consumer_id)}&wrap_callback=#{callback_url}"
        r.finish
      end
    
      def callback_phase
        Rack::Client.new(consumer_options[:site]).post(consumer_options[:access_token_path], {
                            'wrap_client_id'         => consumer_key(consumer_id),
                            'wrap_client_secret'     => consumer_secret(consumer_id),
                            'wrap_verification_code' => http_parameters['wrap_verification_code'],
                            'wrap_callback'          => callback_url
                          }).body.each do |res|
                  @rh = parse_parameters(res)
                  request['auth'] = self.auth_hash
          end
        @app.call(self.env)
      end

      def callback_url
        uri = URI.parse(request.url)
        uri.path += '/callback' unless uri.path[/\/callback$/]
        uri.query = nil
        uri.to_s
      end

      def http_parameters
        Rack::Utils.parse_nested_query(URI.parse(request.url).query)
      end

      def parse_parameters(query_formatted_string)
        CGI.parse(query_formatted_string).inject({}) {|m,x| k,v = x ; m[k] = v[0] ; m}
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'uid'         => @rh['uid'],
          'credentials' => {
            'access_token'  => @rh['wrap_access_token'], 
            'refresh_token'  => @rh['wrap_refresh_token']
          }
        })
      end
      
      def unique_id
        nil
      end

    end
      
  end

end
