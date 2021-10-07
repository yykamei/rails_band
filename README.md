# rails_band

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

You can do what you want for the Rails Instrumentation hooks! These are just examples, so you can also use it for non-logging purposes.

## Contributing

Contributing is welcome 😄 Please open a pull request!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
