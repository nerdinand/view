if ENV['COVERALL']
  require 'coveralls'
  Coveralls.wear!
end

require 'hanami/utils'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.disable_monkey_patching!

  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed
end

TEMPLATE_ROOT_DIRECTORY = Pathname.new __dir__ + '/support/fixtures/templates'

$LOAD_PATH.unshift 'lib'
require 'hanami/view'

require_relative 'unloadable.rb'
require_relative 'helpers.rb'

Hanami::Utils.require!('spec/support')

Hanami::View.configure do
  root TEMPLATE_ROOT_DIRECTORY
end

Hanami::View.load!

Hanami::View.class_eval do
  extend Unloadable
end

unless ENV['TRAVIS']
  require 'byebug'
end