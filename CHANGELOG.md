# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Ruby 3.2.x support
- Ruby 3.3.x support
- Rails 7.1.x support
- Rails 7.2.x support

### Removed
- Ruby 2.7.x support
- Support for Rails < 7.x

### Changed
- CI to test against Ruby 3.2.x
- CI to test against Ruby 3.3.x

## [2.1.0] - 2022-01-07
### Added
- Ruby 3.1.x support
- Rails 7.0.x support

### Changed
- Require Ruby >= 2.7.5
- CI to test against Ruby 3.1.x
- CI to test against Rails 7.0.x

### Removed
- Ruby 2.6.x support

## [2.0.1] - 2020-12-31
### Removed
- Ruby 2.5.x support

## [2.0.0] - 2020-12-31
### Added
- Campaign engagement payload example to README
- Support for Rails 6.1.x

### Changed
- Required version of rake for development
- Standardize style/format of gem code with [StandardRB](https://github.com/testdouble/standard)
- CI to test against Ruby 2.7.x
- Required Ruby version to permit 3.0.x
- CI to test against Ruby 3.0.x
- CI to test against Rails 6.1.x

### Removed
- Rails 5.2.x support

## [1.0.0] - 2019-07-26
### Added
- Mountable Rails engine as API
- POST /api/webhook resource requiring JSON payload for asynchronous dispatching and processing
- Require inbound POST requests be authorization requests with an auth token
- Support for Rails 5.2.x, 6.0.x
- Data models for campaign engagement event payloads
- Helper method to get specific campaign engagement answer
- Payload operation library to dispatch and process deserialized JSON with supported event data modeling
- Processable behavior definition for app implementors
- Default processor mixing in processable behavior with noisy errors
- ActiveJob library for asynchronous handling of payload dispatching and processing
- Configuration support for required app implementation values

### Changed
- Require Ruby >= 2.5
- CI to test against Ruby 2.5.5, 2.6.3
- CI to test against Rails 5.2.x, 6.0.x

## [0.1.1] - 2019-07-16
### Changed
- Changelog URI to correct value in gemspec

## [0.1.0] - 2019-07-16
### Added
- NOOP gem configured for development
