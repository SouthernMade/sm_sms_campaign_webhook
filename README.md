# SmSmsCampaignWebhook: Middleware providing webhook for Southern Made SMS Campaign Engagement

[![Gem Version](https://badge.fury.io/rb/sm_sms_campaign_webhook.svg)](https://badge.fury.io/rb/sm_sms_campaign_webhook)
[![Travis Build Status](https://travis-ci.org/SouthernMade/sm_sms_campaign_webhook.svg?branch=develop)](https://travis-ci.org/SouthernMade/sm_sms_campaign_webhook)
[![Code Climate Maintainability](https://api.codeclimate.com/v1/badges/2298f12a7d6f31688c9c/maintainability)](https://codeclimate.com/github/SouthernMade/sm_sms_campaign_webhook/maintainability)
[![Code Climate Test Coverage](https://api.codeclimate.com/v1/badges/2298f12a7d6f31688c9c/test_coverage)](https://codeclimate.com/github/SouthernMade/sm_sms_campaign_webhook/test_coverage)

This gem will help app implementors using [Rails](https://rubyonrails.org) setup a webhook to ingest data from Southern Made's SMS campaign service. Processing the data can help with:

- user engagement
- entry tracking
- vote tracking
- data report
- other useful things

Work closely with your Southern Made project manager to gather details about what needs to be tracked, what fields to verify, and which scenarios are expected to be supported!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sm_sms_campaign_webhook'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sm_sms_campaign_webhook

## Usage

Right now, nothing happens! Soon, some useful details will emerge about how to ingest the SMS campaign payloads.

## Development

This gem uses [git-flow](https://github.com/nvie/gitflow) to manage deployments. The default branches are used to manage development and production code.

### Versioning

Gem versioning follows [Semantic Versioning](https://semver.org).


### Testing

This project uses Rspec for testing. Specs must be green for any PR to be accepted!

    $ bundle exec rspec

The project is setup with [Travis CI](https://travis-ci.org) to automate test. The various environments that are regularly tested can be seen in [.travis.yml](https://github.com/SouthernMade/sm_sms_campaign_webhook/blob/develop/.travis.yml).

### Documentation

Library documentation is managed using [YARD](https://yardoc.org). Ideally, the documentation remains 100% covered as development progresses.

    $ bundle exec yard

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SouthernMade/sm_sms_campaign_webhook. Pull requests should be made against the develop branch. Extreme cases that require updates to supported gem versions will be handled case by case.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
