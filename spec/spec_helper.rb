require File.expand_path("../../lib/proxy_enforce", __FILE__)
#require "webmock"
#require "webmock/rspec"

RSpec.configure do |config|
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))]
    .each {|f| require f}

  config.include MockUtils

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  #config.profile_examples = 10
  config.order = :random

  Kernel.srand config.seed
end
