module ProxyEnforce
  module Negotiators
    class Request
      def initialize(req)
        @req = req
      end

      def status_code
        @req.status_code
      end

      def host
        @req.host
      end

      def port
        @req.port
      end

      def protocol
        @req.protocol
      end

      def to_hash(opts={})
        {
          host: host,
          port: port,
          protocol: protocol
        }
      end

      def self.build(req)
        klass = if req.kind_of?(Net::HTTPGenericRequest)
          self
        else
          self
        end
        klass.new(req)
      end
    end
  end
end
