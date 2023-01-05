# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [2.2.0] - 2023-01-05

### Added

* Support for Ruby 3.2

## [2.1.0] - 2022-02-23

### Added

* Support for ruby 3.1
* Require bundler-audit >= 0.9

## [2.0.0] - 2021-03-22

### Added

* Require bundler-audit 0.8
* Added Ruby 3.0 to the Travis matrix

### Removed

* Removed support for bundler-audit 0.7

## [1.3.0] - 2020-07-01

### Added

* Added Ruby 2.5, 2.6, and 2.7 to the Travis matrix
* Added the ability to ignore an advisory by its GHSA identifier

### Changed

* Bumped the bundler-audit version to 0.7
* Bumped the Ruby version for development to 2.7.1
* Bumped the Pry version for development to 0.13
* Bumped the Rake version for development to 13
* Bumped the Rspec version for development to 3.9
* Bumped the RuboCop version for development to 0.86
* Bumped the Timecop verison for development to 0.9
* RuboCop fixes

### Removed

* Removed Ruby 2.1 through 2.4 from the Travis matrix
* Removed the explicit Bundler dependency for development, since it is now included with RubyGems

## [1.2.0] - 2017-09-21

### Added

* Added 2.4 to the Travis matrix ([@errm])

### Changed

* Bumped the bundler-audit version to 0.6 ([@errm])
* Bumped the RuboCop version for development to 0.50 ([@errm])
* Bumped the Ruby version for development to 2.4.2 ([@errm])

## [1.1.0] - 2016-09-15

### Added

* Added a matrix build of 2.1, 2.2, and 2.3 to Travis

### Changed

* Added a [Code of Conduct](CODE_OF_CONDUCT.md)
* Bumped the bundler-audit version to 0.5
* Bumped the RSpec version for development to 3.5
* Bumped the Rake version for development to 11.2
* Bumped the RuboCop version for development to 0.42
* Bumped the Ruby version for development to 2.3.1

## [1.0.1] - 2016-02-03

### Fixed

* [#1](https://github.com/civisanalytics/ruby_audit/pull/1)
  removing unreliable last-update check

## 1.0.0 (2016-02-03)

* Initial Release

[Unreleased]: https://github.com/civisanalytics/ruby_audit/compare/v2.0.0...HEAD
[1.3.0]: https://github.com/civisanalytics/ruby_audit/compare/v1.3.0...v2.0.0
[1.3.0]: https://github.com/civisanalytics/ruby_audit/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/civisanalytics/ruby_audit/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/civisanalytics/ruby_audit/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/civisanalytics/ruby_audit/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/civisanalytics/ruby_audit/commit/7535b70412641c888c80d99514b27ba254fb8316

[@errm]: https://github.com/errm
