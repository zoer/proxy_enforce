module ProxyEnforce
  class AdapterRegistry
    include Singleton

    def initialize
      @adapters = {}
    end

    def register(lib, adapter)
      @adapters[lib] = adapter
    end

    def each(&block)
      @adapters.values.each(&block)
    end
  end
end
