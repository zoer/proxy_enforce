module ProxyEnforce
  class Proxy
    include Hooks

    attr_reader :host, :port, :user, :password

    define_hook :after_initialize
    define_hook :after_request

    after_request :send_request_info
    #Config.instance.proxy_hooks.each do |name, block|
      #send(name, blcok)
    #end

    def initialize(options)
      options.each do |key, value|
        next if %w(host port user password).include?(key)
        instance_variable_set("@#{key}", value)
      end

      @max_retry = options["proxy_max_fail"] ||
        ProxyEnforce.config.proxy_max_fail

      run_hook :after_initialize
    end

    def match?
      true
    end

    def performed(req, res, err)
      req = Negotiators::Request.build(req)
      res = Negotiators::Response.build(res)
      err = Negotiators::Error.build(err)
      run_hook :after_request, req, res, err
    end

    def eql?(obj)
      %w(host port user).all? do |key|
        send(key) == obj.send(key)
      end
    end

    def update(obj)
      %w(host port user password).each do |att|
        instance_variable_set(:"@#{att}", obj.send(att))
      end
    end

    private

    def send_request_info(req, res, err)

    end
  end
end
