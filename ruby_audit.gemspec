lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_audit/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_audit'
  spec.version       = RubyAudit::VERSION
  spec.authors       = ['Jeff Cousens, Mike Saelim', 'John Zhang', 'Cristina Muñoz']
  spec.email         = ['opensource@civisanalytics.com']

  spec.summary       = 'Checks Ruby and RubyGems against known vulnerabilities.'
  spec.description   = 'RubyAudit checks your current version of Ruby and ' \
                       'RubyGems against known security vulnerabilities ' \
                       '(CVEs), alerting you if you are using an insecure ' \
                       'version. It complements bundler-audit, providing ' \
                       'complete coverage for your Ruby stack.'
  spec.homepage      = 'https://github.com/civisanalytics/ruby_audit'
  spec.license       = 'GPL-3.0-or-later'

  spec.required_ruby_version = ['>= 2.5', '< 3.3']
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler-audit', '~> 0.9.0'
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 1.9.1'
  spec.add_development_dependency 'timecop', '~> 0.9.1'
end
