
module OmniAuth
  module Stores
    class Redis < Base
      
      def initialize(connection)
        raise ArgumentError, "connection is not Redis connection" unless connection.class == ::Redis
      end

    end
  end
end
