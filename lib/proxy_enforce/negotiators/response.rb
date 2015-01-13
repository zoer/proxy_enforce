module ProxyEnforce
  module Negotiators
    class Response
      def initialize(res)
        @res = res
      end

      def status_code
        @res.status_code
      end

      def self.build(res)
        klass = if res.kind_of?(Net::HTTPResponse)
          self
        else
          self
        end
        klass.new(res)
      end
    end
  end
end
