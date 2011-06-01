
module OmniAuth
  module Stores
    class Base < Object

      attr_accessor :connection

      def key(identifier, for_strategy = nil)
        raise NotImplementedError 
      end

      def secret(identifier, for_strategy = nil)
        raise NotImplementedError        
      end

      def callback(identifier)
        raise NotImplementedError        
      end

      def strategy
        raise NotImplementedError
      end

    end
  end
end
