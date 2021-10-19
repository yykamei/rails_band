# rails_band

<a href="https://github.com/yykamei/rails_band/actions/workflows/ci.yml"><img alt="GitHub Actions workflow status" src="https://github.com/yykamei/rails_band/actions/workflows/ci.yml/badge.svg"></a>
<a href="https://rubygems.org/gems/rails_band"><img alt="Gem" src="https://img.shields.io/gem/v/rails_band"></a>

Easy-to-use Rails Instrumentation API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_band'
```

And then execute:

```console
bundle
```

Or install it yourself as:
```console
gem install rails_band
```

## Usage

rails_band automatically replaces each `LogSubscriber` with its own ones after it's loaded as a gem.
And then, you should configure how to consume Instrumentation hooks from core Rails implementations like this:

```ruby
Rails.application.config.rails_band.consumers = ->(event) { Rails.logger.info(event.to_h) }
```

You can also configure it by specifying event names:

```ruby
Rails.application.config.rails_band.consumers = {
  default: ->(event) { Rails.logger.info(event.to_h) },
  action_controller: ->(event) { Rails.logger.info(event.slice(:name, :method, :path, :status, :controller, :action)) },
  'sql.active_record': ->(event) { Rails.logger.debug("#{event.sql_name}: #{event.sql}") },
}
```

Note `:default` is the fallback of other non-specific event names. Other events will be ignored without `:default`.
In other words, you can consume only events that you want to really consume without `:default`.

rails_band does not limit you only to use logging purposes. Enjoy with Rails Instrumentation hooks!

## Contributing

Contributing is welcome 😄 Please open a pull request!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
