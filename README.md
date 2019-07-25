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

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
  - [Auto Generate Config](#auto-generate-config)
  - [Webhook Auth Token](#webhook-auth-token)
  - [ActiveJob](#activejob)
  - [Mount the Webhook Engine](#mount-the-webhook-engine)
  - [Webhook Initializer](#webhook-initializer)
  - [Payload Processor](#payload-processor)
- [Usage](#usage)
  - [Campaign Engagement](#campaign-engagement)
- [Development](#development)
  - [Versioning](#versioning)
  - [Testing](#testing)
  - [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Installation

This gem is tested with Rails 5.2.x, 6.0.x versions.

Add this line to your application's Gemfile:

```ruby
gem 'sm_sms_campaign_webhook'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sm_sms_campaign_webhook

## Configuration

These are the steps to configure your app to be ready to capture SMS campaign service payloads.

### Auto Generate Config

You can setup most app configuration by running the generator:

```
$ bundle exec rails generate sm_sms_campaign_webhook:install
```

Some things will still require manual configuration and will be identified after generation.

If you prefer to setup everything by hand, continue to the next sections!

### Webhook Auth Token

The SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN value is required to be an ENV value to avoid leaking production values. It will be used to authorize payload requests from the SMS campaign service.

Set this value using the rails secret generator:

```
$ bundle exec rails secret
```

And copy the result to your `.env` or applicable config file:

```
SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN="******"
```

### ActiveJob

Payloads will be dispatched and processed asynchronously using [ActiveJob](https://edgeguides.rubyonrails.org/active_job_basics.html). Southern Made prefers that the app be configured with [Sidekiq](https://github.com/mperham/sidekiq) as the queue adapter.

You can set the adapter in `config/application.rb` with:

```ruby
class Application < Rails::Application
  config.active_job.queue_adapter = :sidekiq
end
```

Update your Procfile or appropriate config to launch worker processes:

```
worker: RAILS_MAX_THREADS=${SIDEKIQ_CONCURRENCY:-5} bundle exec sidekiq --config config/sidekiq.yml
```

More detailed instructions about using Sidekiq can be found in the [Sidekiq Wiki](https://github.com/mperham/sidekiq/wiki).

### Mount the Webhook Engine

If you opted to [auto generate the config](#auto-generate-config), this can be skipped.

Add the following to `config/routes.rb` in your app to mount the webhook:

```ruby
mount SmSmsCampaignWebhook::Engine => "/sms_campaign"
```

This sets the app up to receive POST requests from the SMS campaign service:

    POST /sms_campaign/api/webhook

Be sure to replace `/sms_campaign` with whatever mount point you choose. Once you share the webhook URI with your project manager, avoid changing it; they will configure it with the correspending SMS campaign!

### Webhook Initializer

If you opted to [auto generate the config](#auto-generate-config), this can be skipped.

App implementors must configure some library options. Here are all supported configuration options identifying their default values for `config/initializers/sm_sms_campaign_webhook.rb`:

```ruby
require "sm_sms_campaign_webhook"

SmSmsCampaignWebhook.config do |config|
  # SMS campaign payload processor implementing SmSmsCampaignWebhook::Processable behavior.
  # default: SmSmsCampaignWebhook::DefaultProcessor (raises errors for processing)
  # config.processor = SmsPayloadProcessor
end
```

### Payload Processor

If you opted to [auto generate the config](#auto-generate-config), this can be skipped. However, you will still need to implement the processor methods!

The default payload processor will raise errors while processing. You are required to provide a working payload processor to properly handle the data received from the SMS campaign service.

To create a processor, create a custom class mixing in `SmSmsCampaignWebhook::Processable` behavior. For example, we can create a custom processor named `SmsPayloadProcessor`:

```ruby
class SmsPayloadProcessor
  include SmSmsCampaignWebhook::Processable

  # Implement required methods for Processable behavior.

  # @param campaign_engagement [SmSmsCampaignWebhook::CampaignEngagement]
  # def self.process_campaign_engagement(campaign_engagement)
  #   # NOOP - I need to be implemented.
  # end
end
```

This class will continue raising errors until the required methods are implemented. Please see the [Processable mixin](https://github.com/SouthernMade/sm_sms_campaign_webhook/blob/develop/app/processors/sm_sms_campaign_webhook/processable.rb) for expected method definitions.

Finally the configuration needs to be updated to use the custom processor. Add this within the config block in `config/initializers/sm_sms_campaign_webhook.rb`:

```ruby
SmSmsCampaignWebhook.config do |config|
  #...
  config.processor = SmsPayloadProcessor
  #...
end
```

## Usage

The main goal is to ingest the data contained in payloads received from the SMS campaign service. Your app knows best what to do with the data, so your primary focus is implementing the required methods of a payload processor.

Assuming that you completed configuration with the [auto generate installer](#auto-generate-config) or [manually created a processor](#payload-processor), this section will expand what to do with it.

### Campaign Engagement

This payload represents a user's phone interaction with the SMS campaign. This includes:

- First contact with a SMS campaign by keyword
- Responding to subsequent SMS campaign messages
- Continued engagement for multi-entry SMS campaigns

Payloads will POST to the webhook every time a phone interacts with the campaign, so the processor behavior should expect to see repeats of inbound payloads from a phone!

It is important that you work closely with your Southern Made project manager to determine which scenarios are relevant for your app. They will be able to tell you:

- Fields + value types that will be in answers
- Required fields to complete registration/entry
- How to interpret voting style numeric answers

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
