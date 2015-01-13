require "spec_helper"

RSpec.describe ProxyEnforce::Proxy do
  let(:klass) { described_class }
  let(:args) { {host: "1.1.1.1", port: 8080, user: "test", password: "123"} }
  let(:proxy) { klass.new(args) }

  describe "#initialize" do
    it "assing variables"do
      args.each do |key, value|
        expect(proxy.send(key)).to eq value
      end
    end

    it "run hook" do
      expect_any_instance_of(klass).to receive(:run_hook)
        .with(:after_initialize).and_call_original
      klass.new(args)
    end
  end

  describe "#eql?" do
    let(:proxy) { klass.new(args) }
    let(:proxy_equal) { klass.new(args) }
    let(:diff_password) { klass.new(args.merge(password: "321")) }
    let(:diff_user) { klass.new(args.merge(user: "foo")) }
    let(:diff_port) { klass.new(args.merge(port: 3128)) }
    let(:diff_host) { klass.new(args.merge(host: "foo")) }

    it "with equal proxy" do
      expect(proxy.eql?(proxy_equal)).to eq true
    end

    it "with different password" do
      expect(proxy.eql?(diff_password)).to eq true
    end

    it "with different user" do
      expect(proxy.eql?(diff_user)).to eq false
    end

    it "with different port" do
      expect(proxy.eql?(diff_port)).to eq false
    end

    it "with different host" do
      expect(proxy.eql?(diff_host)).to eq false
    end
  end

  describe "#performed" do
    let(:req) { Net::HTTP::Get.new("/") }
    let(:res) { Net::HTTPSuccess.new("", 200, "OK") }
    let(:err) { Net::HTTPError.new("", "") }

    it "run hook" do
      expect(proxy).to receive(:run_hook).and_call_original
      expect(proxy).to receive(:send_request_info).with(
        kind_of(ProxyEnforce::Negotiators::Request),
        kind_of(ProxyEnforce::Negotiators::Response),
        kind_of(ProxyEnforce::Negotiators::Error),
      ).and_call_original
      proxy.performed(req, res, err)
    end
  end

  describe "#match?" do
    it "test match"
  end

  describe "#update" do
    let(:proxy2) { klass.new(host: "23.23.23.23", port: 2020) }
    before(:each) { proxy2.update(proxy) }

    it "update proxy settings" do
      expect(proxy2.host).to eq proxy.host
      expect(proxy2.port).to eq proxy.port
      expect(proxy2.user).to eq proxy.user
      expect(proxy2.password).to eq proxy.password
    end
  end
end
