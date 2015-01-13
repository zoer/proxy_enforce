require "spec_helper"

RSpec.describe ProxyEnforce::Config do
  let(:klass) { described_class }

  it "Provide default values" do
    assert_config_default :proxy_max_fail, 10
    assert_config_default :reconnect_on_fail, true
    assert_config_default :reconnect_max_try, 20
  end

  it "Allow overwrite values" do
    assert_config_overridable :proxy_max_fail
    assert_config_overridable :reconnect_on_fail
    assert_config_overridable :reconnect_max_try
  end

  def assert_config_default(option, default_value)
    config ||= klass.new
    expect(config.send(option)).to eq default_value
  end

  def assert_config_overridable(option, value = 'some value')
    config ||= klass.new
    config.send(:"#{option}=", value)
    expect(config.send(option)).to eq value
  end
end
