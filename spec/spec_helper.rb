$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pry'
require 'ruby_audit'

RSpec.configure do |config|
  config.before(:each) do
    stub_const('Bundler::Audit::Database::DEFAULT_PATH',
               File.join(File.dirname(__FILE__), '..', 'vendor',
                         'ruby-advisory-db'))
  end
end
