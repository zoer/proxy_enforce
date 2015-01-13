require "singleton"
require "hooks"

module ProxyEnforce
  autoload :Version, "lib/version"
  autoload :Config, "proxy_enforce/config"

  autoload :Proxy, "proxy_enforce/proxy"
  autoload :ProxyRegistry, "proxy_enforce/proxy_registry"
  autoload :ProxyRepository, "proxy_enforce/proxy_repository"

  autoload :AdapterRegistry, "proxy_enforce/adapter_registry"
  module Adapters
    autoload :Base, "proxy_enforce/adapters/base"
    autoload :NetHttp, "proxy_enforce/adapters/net_http"
  end

  module Negotiators
    autoload :Request, "proxy_enforce/negotiators/request"
    autoload :Response, "proxy_enforce/negotiators/response"
    autoload :Error, "proxy_enforce/negotiators/error"
  end

  module Errors
    autoload :Base, "proxy_enforce/errors/base"
    autoload :MatchProxyNotFound, "proxy_enforce/errors/match_proxy_not_found"
  end

  class << self
    def enable!
      AdapterRegistry.instance.each do |adapter|
        adapter.enable!
      end
    end

    def disable!
      AdapterRegistry.instance.each do |adapter|
        adapter.disable!
      end
    end

    def configure
      yield(config)
    end

    def config
      @config ||= Config.new
    end
  end

  [
     [:net_http, Adapters::NetHttp]
  ].each do |c|
    AdapterRegistry.instance.register(c.first, c.last)
  end
end
