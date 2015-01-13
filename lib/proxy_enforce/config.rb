module ProxyEnforce
  class Config

    attr_accessor :reconnect_on_fail
    attr_accessor :reconnect_max_try
    attr_accessor :proxy_max_fail

    def initialize
      @reconnect_on_fail = true
      @reconnect_max_try = 20
      @proxy_max_fail = 10
    end
  end
end
