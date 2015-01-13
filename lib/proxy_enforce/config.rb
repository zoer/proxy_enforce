module ProxyEnforce
  class Config

    attr_reader :reconect_on_fail
    attr_reader :proxy_max_fail

    def initialize
      @reconnect_on_fail = true
      @reconnect_max_try = 20
      @proxy_max_try = 10
    end
  end
end
