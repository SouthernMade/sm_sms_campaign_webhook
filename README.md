# SmSmsCampaignWebhook: Middleware providing webhook for Southern Made SMS Campaign Engagement

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

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SouthernMade/sm_sms_campaign_webhook.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
