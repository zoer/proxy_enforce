module ProxyEnforce
  class ProxyRegistry
    include Singleton

    attr_accessor :proxies

    def initialize
      reset!
    end

    def reset!
      @proxies = []
      @current_proxy = nil
    end

    def seed(rep)
      rep.proxies.each do |proxy|
        proxy = Proxy.new(proxy)
        existed = get_existed(proxy)
        existed ? existed.update(proxy) : @proxies << proxy
      end
    end

    def get_existed(proxy)
      proxies.each do |old|
        return old if proxy.eql?(old)
      end
      nil
    end

    def next_proxy
      return if @proxies.empty?

      index = @current_proxy ? @proxies.index(@current_proxy) : nil
      if index
        arr = @proxies.drop(index+1)
        arr +=  @proxies[0..index]
      else
        arr = @proxies
      end

      loop do
        arr.each_with_index do |proxy, i|
          #require "byebug"; byebug
          if proxy.match?
            return @current_proxy = proxy
          end
        end
        if defined? full_cicle
          return nil
        else
          full_cicle = true
        end
      end
    end

    def next_proxy!
      next_proxy || raise(Errors::MatchProxyNotFound.new)
    end

    def current_proxy
      @current_proxy ||= next_proxy!
    end
  end
end
