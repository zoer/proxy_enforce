require "spec_helper"

RSpec.describe ProxyEnforce::Adapters::NetHttp do
  it "enable/disable" do
    expect(Net::HTTP).to_not eq ProxyEnforce::Adapters::NetHttp::MockNetHTTP
    ProxyEnforce::Adapters::NetHttp.enable!
    expect(Net::HTTP).to eq ProxyEnforce::Adapters::NetHttp::MockNetHTTP
    ProxyEnforce::Adapters::NetHttp.disable!
    expect(Net::HTTP).to_not eq ProxyEnforce::Adapters::NetHttp::MockNetHTTP
  end

  describe do
    before(:each) do
      ProxyEnforce::ProxyRepository.new.pull
      ProxyEnforce::Adapters::NetHttp.enable!
    end

    skip do
      Net::HTTP.start("myip.ru") do |http|
        request = Net::HTTP::Get.new("/")
        pp request.instance_variable_get(:@header).inspect
        res = http.request(request)
        pp res.body
      end
      ProxyEnforce::Adapters::NetHttp.disable!
    end
  end

  skip "test" do
    stub_socket("test") do
      uri = URI('http://example.com/some_path?query=string')

      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new uri

        response = http.request request # Net::HTTPResponse object
        pp response.body
      end
    end
  end
end
