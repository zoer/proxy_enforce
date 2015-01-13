require "spec_helper"

RSpec.describe ProxyEnforce::ProxyRepository do
  let(:klass) { described_class }
  let(:repository) { klass.new }

  describe "#initialize" do
    it "defaults" do
      expect_any_instance_of(klass).to receive(:reset!)
      klass.new
    end
  end

  describe "#reset!" do
    before(:each) { repository.proxies << :foo }

    it "reset to defauls" do
      expect{repository.reset!}.to change{repository.proxies}.to([])
    end
  end

  describe "#fetch" do
    it "reset to defaults" do
      expect(repository).to receive(:fetch)
      repository.fetch
    end

    it "fetching test"
  end

  describe "#pull" do
    let(:args) { {host: "1.1.1.1", port: 2020} }
    let(:proxy) { ProxyEnforce::Proxy.new(args) }
    let(:registry) { ProxyEnforce::ProxyRegistry.instance }

    before(:each) do
      registry.reset!
      expect(repository).to receive(:fetch) do
        repository.proxies = [args]
      end
    end

    it "pull repository with one proxy" do
      expect{repository.pull}.to change{registry.proxies.count}.by(1)
      expect(registry.proxies.first.eql?(proxy)).to be true
    end
  end
end
