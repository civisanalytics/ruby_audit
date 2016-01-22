$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'ruby_audit'
require 'timecop'

RSpec.configure do |config|
  config.before(:each) do
    stub_const('Bundler::Audit::Database::VENDORED_PATH',
               File.join(File.dirname(__FILE__), '..', 'vendor',
                         'ruby-advisory-db'))
  end
end
