# SmSmsCampaignWebhook

[![Southern Made - Galaxy Logo](https://raw.github.com/SouthernMade/sm_sms_campaign_webhook/develop/logo_galaxymark.png)](https://www.southernmade.com/) by [Southern Made](https://www.southernmade.com/)

[![Gem Version](https://badge.fury.io/rb/sm_sms_campaign_webhook.svg)](https://rubygems.org/gems/sm_sms_campaign_webhook)
[![CI](https://github.com/SouthernMade/sm_sms_campaign_webhook/actions/workflows/ci.yml/badge.svg)](https://github.com/SouthernMade/sm_sms_campaign_webhook/actions/workflows/ci.yml)
[![Linting](https://github.com/SouthernMade/sm_sms_campaign_webhook/actions/workflows/linting.yml/badge.svg)](https://github.com/SouthernMade/sm_sms_campaign_webhook/actions/workflows/linting.yml)
[![Security](https://github.com/SouthernMade/sm_sms_campaign_webhook/actions/workflows/security.yml/badge.svg)](https://github.com/SouthernMade/sm_sms_campaign_webhook/actions/workflows/security.yml)
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
    - [Processor Expections](#processor-expections)
    - [Campaign Engagement Data Model](#campaign-engagement-data-model)
    - [Campaign Engagement Answer Data Model](#campaign-engagement-answer-data-model)
    - [Campaign Engagement Payload Example](#campaign-engagement-payload-example)
- [Development](#development)
  - [Versioning](#versioning)
  - [Testing](#testing)
  - [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Installation

This gem is tested with Rails 7.0.x, 7.1.x, 7.2.x versions.

Add this line to your application's Gemfile:

```ruby
gem "sm_sms_campaign_webhook", "~> 3.0"
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

Some things will still require manual configuration and will be identified after generation:

- [Webhook Auth Token](#webhook-auth-token)
- [ActiveJob](#activejob)

After that, be sure to read the [Usage](#usage) section for payload processor details!

If you prefer to setup everything by hand, be sure to check out:

- [Webhook Initializer](#webhook-initializer)
- [Payload Processor](#payload-processor)

### Webhook Auth Token

The `SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN` value is required to be an `ENV` value to avoid leaking production values. It will be used to authorize payload requests from the SMS campaign service.

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

If you have already chosen another queue adapter then feel free to ignore this step!

You can set the adapter in `config/application.rb` with:

```ruby
class Application < Rails::Application
  config.active_job.queue_adapter = :sidekiq
end
```

Add `config/sidekiq.yml` config with:

```yaml
---
:concurrency: <%= ENV.fetch("SIDEKIQ_CONCURRENCY") { 5 }.to_i %>
:timeout: <%= ENV.fetch("SIDEKIQ_TIMEOUT") { 25 }.to_i %>
:queues:
  - default
  - mailers
```

Add `config/initializers/sidekiq.rb` with:

```ruby
# @note Sidekiq server + client must both be configured for Redis.
# @see https://github.com/mperham/sidekiq/wiki/Using-Redis

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" },
    network_timeout: ENV.fetch("REDIS_NETWORK_TIMEOUT") { 5 }.to_i
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" },
    network_timeout: ENV.fetch("REDIS_NETWORK_TIMEOUT") { 5 }.to_i
  }
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

#### Processor Expections

You must implement behavior for this method to ingest campaign engagement data in your paylod processor:

```ruby
def self.process_campaign_engagement(campaign_engagement)
  # ...
end
```

It will receive an instance of the [SmSmsCampaignWebhook::CampaignEngagement](https://github.com/SouthernMade/sm_sms_campaign_webhook/blob/develop/app/models/sm_sms_campaign_webhook/campaign_engagement.rb) data model. This method will need to handle scenarios such as:

- Registering/creating a user account
- Logging registration/entries
- Interpreting + logging vote responses

Check with your Southern Made project manager for expectations.

#### Campaign Engagement Data Model

The payload will be modeled with the [SmSmsCampaignWebhook::CampaignEngagement](https://github.com/SouthernMade/sm_sms_campaign_webhook/blob/develop/app/models/sm_sms_campaign_webhook/campaign_engagement.rb) class. It provides basic methods to extract values out of the payload. The data model coerces values to the appropriate types in Ruby.

Some example message passing to an instance:

```ruby
campaign_engagement.event_uuid        # UUID - unique payload event
campaign_engagement.campaign_keyword  # String - SMS campaign entry point
campaign_engagement.phone_id          # Integer - represents specific phone
campaign_engagement.phone_number      # String - phone number interacting with SMS campaign

# This represents a specific phone engaging with a specific campaign.
# The value will differ for each entry in multi-entry campaigns.
# For standard campaigns we will only see one value.
campaign_engagement.phone_campaign_state_id   # Integer

# These values help determine if and when answers were received
# for all campaign messages.
campaign_engagement.phone_campaign_state_completed?     # TrueClass,FalseClass
campaign_engagement.phone_campaign_state_completed_at   # DateTime
```

It also provides a useful helper methods related to campaign engagement answers. For example:

```ruby
# Are any campaign engagement answers in the payload?
campaign_engagement.phone_campaign_state_answers? # TrueClass,FalseClass

# This tries to find an answer for the requested field.
# If a match is found it returns instance of
# SmSmsCampaignWebhook::CampaignEngagement::Answer data model.
# If a match is not found it return nil (NilClass).
campaign_engagement.answer_for(field: "email")     # Returned type answer specific
```

#### Campaign Engagement Answer Data Model

The [SmSmsCampaignWebhook::CampaignEngagement::Answer](https://github.com/SouthernMade/sm_sms_campaign_webhook/blob/develop/app/models/sm_sms_campaign_webhook/campaign_engagement/answer.rb) class models the answer data contained in the campaign engagement payload. It consists of:

- field (`String`)
- value (varies)
- collected_at (`DateTime`)

The value data types could be one of the following:

- string (`String`)
- email (`String`)
- date (`Date`)
- number (`Integer`)
- boolean (`TrueClass`, `FalseClass`)
- us_state (`String`)

#### Campaign Engagement Payload Example

Here is an example payload for campaign engagement that could come through to the payload processor. Be sure to check with your Southern Made project manager to gather details about the answer fields and data types:

```json
{
  "uuid": "99aaafe3-b52b-413f-a9cd-db52fa13b77a",
  "object": "event",
  "type": "campaign.engagement",
  "created_at": "2019-08-09T18:29:05.052Z",
  "data": {
    "campaign": {
      "id": 55,
      "keyword": "KEYWORD"
    },
    "phone": {
      "id": 80,
      "number": "3335557777"
    },
    "phone_campaign_state": {
      "id": 95,
      "answers": {
        "DOB": {
          "value": "2001-07-04",
          "collected_at": "2019-08-09T18:26:59.052Z"
        },
        "email": {
          "value": "email@example.com",
          "collected_at": "2019-08-09T18:27:59.052Z"
        },
        "vote-september": {
          "value": 1,
          "collected_at": "2019-08-09T18:28:59.052Z"
        }
      },
      "completed": true,
      "completed_at": "2019-08-09T18:28:59.052Z"
    }
  }
}
```

[cURL](https://curl.haxx.se) example assuming the payload file path is `tmp/sms_campaign_payload.json`, app is running running with mount point `sms_campaign`, web server uses port `3000`, and that you use your app's webhook auth token:

```bash
$ curl \
--header "Authorization: Bearer WEBHOOKAUTHTOKEN" \
--header "Content-Type: application/json" \
--header "Accept: application/json" \
--data @tmp/sms_campaign_payload.json \
http://localhost:3000/sms_campaign/api/webhook
```

## Development

This gem uses [git-flow](https://github.com/nvie/gitflow) to manage deployments. The default branches are used to manage development and production code.

### StandardRB

This project uses [StandardRB](https://github.com/testdouble/standard), a hands-off wrapper around [Rubocop](https://docs.rubocop.org/en/stable/), to manage style/formatting/etc. Please apply changes before submitting pull requests:

    $ bundle exec standardrb --fix

### Versioning

Gem versioning follows [Semantic Versioning](https://semver.org).

### Testing

This project uses Rspec for testing. Specs must be green for any PR to be accepted!

    $ bundle exec rspec

The project is setup with [GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions) to automate testing. The various workflows and environments can be seen in [.github/workflows/ci.yml](https://github.com/SouthernMade/sm_sms_campaign_webhook/blob/develop/.github/workflows/ci.yml).

### Documentation

Library documentation is managed using [YARD](https://yardoc.org). Ideally, the documentation remains 100% covered as development progresses.

    $ bundle exec yard

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SouthernMade/sm_sms_campaign_webhook. Pull requests should be made against the develop branch. Extreme cases that require updates to supported gem versions will be handled case by case.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
