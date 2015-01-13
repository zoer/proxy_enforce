require 'net/http'
require 'net/https'

module ProxyEnforce
  module Adapters
    class NetHttp
      include Base

      OriginalNetHTTP = Net::HTTP unless const_defined?(:OriginalNetHTTP)

      def self.enable!
        Net.send(:remove_const, :HTTP)
        Net.send(:remove_const, :HTTPSession)
        Net.send(:const_set, :HTTP, MockNetHTTP)
        Net.send(:const_set, :HTTPSession, MockNetHTTP)
      end

      def self.disable!
        Net.send(:remove_const, :HTTP)
        Net.send(:remove_const, :HTTPSession)
        Net.send(:const_set, :HTTP, OriginalNetHTTP)
        Net.send(:const_set, :HTTPSession, OriginalNetHTTP)
      end

      class MockNetHTTP < ::Net::HTTP
        def connect
          @proxy_address = current_proxy.host
          @proxy_port = current_proxy.port
          @proxy_user = current_proxy.user
          @proxy_pass = current_proxy.password
          super
        end

        def current_proxy
          proxy_registry.current_proxy
        end

        def proxy?
          current_proxy
        end

        def request(req, body = nil, &block)
          res = super
          process_callbacks(req, res)
          res
        rescue ::Net::HTTPProxyAuthenticationRequired => err
          process_callbacks(req, nil, err)
          if Config.instance.reconect_on_fail && proxy_registry.next_proxy!
            do_start
            super
          else
            raise err
          end
        end

        def process_callbacks(req, res, err=nil)
          current_proxy.performed(req, res, err) if proxy?
        end

        private

        def proxy_registry
          ProxyEnforce::ProxyRegistry.instance
        end
      end

      %w(Delete Put Head Get Post Options).each do |c|
        MockNetHTTP.const_set(c, Net::HTTP.const_get(c))
      end
    end
  end
end
