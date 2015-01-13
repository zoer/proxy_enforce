module ProxyEnforce
  module Negotiators
    class Error
      def initialize(err)
        @err = err
      end

      def message
        @err.message
      end

      def name
        err.class.name
      end

      def to_hash(opts={})
        {
          message: message,
          name: name
        }
      end

      def self.build(err)
        new(err)
      end
    end
  end
end
