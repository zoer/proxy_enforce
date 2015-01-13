TCP_NEW = TCPSocket.method(:open) unless defined? TCP_NEW

class FakeTCPSocket
  def initialize(remote_host, remote_port, local_host=nil, local_port=nil)
    @remote_host, @remote_port, @local_host, @local_port =
      remote_host, remote_port, local_host, local_port
    @closed = false
    @status_code = 200
  end

  #def self.open(remote_host, remote_port, local_host=nil, local_port=nil)
    #new(remote_host, remote_port, local_host, local_port)
  #end

  def readline(some_text = nil)
    @content || ""
  end

  def read_nonblock(max_length)
    response.read(max_length)
  end

  def setsockopt(*args)
  end

  def flush
  end

  def write(some_text = nil)
    0
  end

  def read(num)
    response.read(num)
  end

  def closed?
    @closed
  end

  def close
    @closed = true
  end

  def set_content(text)
    @content = text
  end

  def content
    @content
  end

  private

  def headers
    [
      "HTTP/1.1 #{status_code} #{codes[status_code]}",
      "Content-Type: text/html; charset=utf-8",
      "Content-Length: #{content.length}"
    ].join("\n")
  end

  def status_code
    @status_code.to_i
  end

  def response
    @response ||= StringIO.new "#{headers}\n\n#{content}"
  end

  def codes
    {
      200 => "OK",
      404 => "Not Found",
      407 => "Proxy Authentication Required"
    }
  end
end

module MockUtils
  def stub_socket(content = nil)
    allow(TCPSocket).to receive(:open) do |*args|
      s = FakeTCPSocket.new(*args)
      s.set_content(content) if content
      s
    end
    yield
  ensure
    allow(TCPSocket).to receive(:open) { |*args| TCP_NEW.call(*args) }
  end
end
