
module OmniAuth
  module Stores
    class Redis < Base

      attr_accessor :strategy
      
      def initialize(con, strat = nil)
        raise ArgumentError, "is not Redis connection" unless con.class == ::Redis
        self.connection, self.strategy = con, strat
      end

      def key(ident, strat = nil)
        strat ||= self.strategy
        self.connection.lindex("#{ident}:#{strat}", 0)
      end

      def secret(ident, strat = nil)
        strat ||= self.strategy
        self.connection.lindex("#{ident}:#{strat}", 1)
      end

      def callback(ident)
        self.connection.get("#{ident}:mask")
      end

    end
  end
end
