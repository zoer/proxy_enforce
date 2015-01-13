module ProxyEnforce
  class ProxyRepository

    attr_accessor :proxies

    def initialize
      reset!
    end

    def fetch
      reset!
      @proxies = [
        {
          host: "1.1.1.1",
          port: 8080,
          user: nil,
          password: nil,
          country: "RU"
        }
      ]
    end

    def pull
      fetch
      ProxyRegistry.instance.seed(self)
    end

    def reset!
      @proxies = []
    end
  end
end
