# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Mountable Rails engine as API
- POST /api/webhook resource requiring JSON payload for asynchronous dispatching and processing
- Support for Rails 5.2.x, 6.0.x
- Data models for campaign engagement event payloads
- Helper method to get specific campaign engagement answer
- Payload operation library to dispatch and process deserialized JSON with supported event data modeling
- ActiveJob library for asynchronous handling of payload dispatching and processing

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
