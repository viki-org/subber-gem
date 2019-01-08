require 'bundler/setup'
require 'subber'

module IsExpectedBlock
  def is_expected_block
    expect { subject }
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  config.expose_dsl_globally = true

  config.include IsExpectedBlock

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def read_fixture(filename)
  open(File.join(File.expand_path('.'), 'spec', 'fixtures', filename)).read
end

def read_compact_json_fixture(filename)
  json = open(File.join(File.expand_path('.'), 'spec', 'fixtures', filename)).read
  JSON.parse(json).to_json
end
