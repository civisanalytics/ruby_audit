# RubyAudit

![Build Status](https://github.com/civisanalytics/ruby_audit/actions/workflows/test.yml/badge.svg)
[![Gem Version](https://badge.fury.io/rb/ruby_audit.svg)](http://badge.fury.io/rb/ruby_audit)

RubyAudit checks your current version of Ruby and RubyGems against known security vulnerabilities (CVEs), alerting you if you are using an insecure version.
It complements [bundler-audit](https://github.com/rubysec/bundler-audit), providing complete coverage for your Ruby stack.
If you use Bundler, you should use both RubyAudit and bundler-audit.

RubyAudit is based on and leverages bundler-audit, and would not exist without the hard work of the [rubysec](https://github.com/rubysec) team, specifically bundler-audit and [ruby-advisory-db](https://github.com/rubysec/ruby-advisory-db).

"If I have seen further it is by standing on the shoulders of Giants." -- Isaac Newton

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_audit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_audit

Because bundler-audit requires bundler, RubyAudit requires bundler as a transitive
dependency.  If you don't intend to run RubyAudit in the production environment, you
may selectively install it in your development and test environments by using
[Bundler groups](https://bundler.io/guides/groups.html).

## Usage

To check your current version of Ruby and RubyGems:

```bash
$ ruby-audit check
```

You can ignore specific advisories by specifying `-i <advisory>`:

```bash
$ ruby-audit check -i CVE-2015-7551
```

By default, RubyAudit will check for updates to the ruby-advisory-db when it runs.
If you are using RubyAudit offline, you can bypass this check by specifying `-n`:

```bash
$ ruby-audit check -n
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
You'll also want to run `git submodule update --init` to populate the ruby-advisory-db
submodule used for testing. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## License

RubyAudit is released under the [GNU General Public License version 3](LICENSE.md).
