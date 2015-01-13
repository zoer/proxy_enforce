require "spec_helper"

RSpec.describe ProxyEnforce::ProxyRegistry do

  let(:registry) { described_class.instance }
  let(:proxy_server_settings) { {host: "1.1.1.1", port: 80} }
  let(:proxy) { ProxyEnforce::Proxy.new(proxy_server_settings) }

  before(:each) { registry.reset! }

  it "defaults" do
    expect(registry.proxies).to eq []
    expect(registry.instance_variable_get(:@current_proxy)).to be_nil
  end

  describe "#reset!" do
    before(:each) do
      registry.proxies = [1]
      registry.instance_variable_set(:@current_proxy, proxy)
      registry.reset!
    end

    it "reset registry variables" do
      expect(registry.proxies).to eq []
      expect(registry.instance_variable_get(:@current_proxy)).to be_nil
    end
  end

  describe "#get_existed" do
    let(:proxy_eql) { false }

    before(:each) do
      allow_any_instance_of(described_class).to \
        receive(:proxies).and_return([proxy])
      allow_any_instance_of(ProxyEnforce::Proxy).to \
        receive(:eql?).and_return(proxy_eql)
    end

    it "has no existed proxy" do
      expect(registry.get_existed(proxy)).to be_nil
    end

    context "has one existed proxy" do
      let(:proxy_eql) { true }

      it { expect(registry.get_existed(proxy)).to eq proxy }
    end
  end

  describe "#seed" do
    let(:repository) { ProxyEnforce::ProxyRepository.new }
    let(:new_server_settings) { {host: "1.2.3.4", port: 8080} }
    let(:new_proxy) { ProxyEnforce::Proxy.new(new_server_settings) }

    before(:each) do
      registry.proxies = [proxy]
      repository.proxies = [proxy_server_settings, new_server_settings]
    end

    it "with 1 new and 1 old proxies" do
      expect do
        registry.seed(repository)
      end.to change{registry.proxies.count}.from(1).to(2)
      expect(registry.proxies.first).to eq proxy
      expect(registry.proxies.last.eql?(new_proxy)).to_not be_nil
    end
  end

  describe "#next_proxy" do

    (1..3).each do |n|
      let(:"proxy#{n}") do
        ProxyEnforce::Proxy.new(host:"2.2.2.#{n}", port: 8080)
      end
      before(:each) { registry.proxies << send("proxy#{n}") }
    end

    it do
      expect(registry.proxies.count).to eq 3
      expect(registry.next_proxy).to eq proxy1
      expect(registry.next_proxy).to eq proxy2
      expect(registry.next_proxy).to eq proxy3
      expect(registry.next_proxy).to eq proxy1
    end

    context "make sure that match? method is called" do
      before(:each) do
        allow_any_instance_of(ProxyEnforce::Proxy).to \
          receive(:match?) { |inst| "2.2.2.2" == inst.host }
      end

      it "with only one matched proxy" do
        expect(registry.next_proxy).to eq proxy2
        expect(registry.next_proxy).to eq proxy2
      end
    end
  end

  describe "#next_proxy!" do
    it "raise error" do
      expect{ registry.next_proxy! }.to \
        raise_error(ProxyEnforce::Errors::MatchProxyNotFound)
    end

    it "get next proxy" do
      allow(registry).to receive(:next_proxy).and_return(proxy)
      expect(registry.next_proxy!).to eq proxy
    end
  end

  it "#current_proxy" do
    expect(registry).to receive(:next_proxy!).once.and_return(proxy)

    expect(registry.current_proxy).to eq proxy
    expect(registry.current_proxy).to eq proxy
  end
end
