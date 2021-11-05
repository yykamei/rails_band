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

## Supported Instrumentation API hooks

### Action Controller

* [x] [`write_fragment.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#write-fragment-action-controller)
* [x] [`read_fragment.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#read-fragment-action-controller)
* [x] [`expire_fragment.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#expire-fragment-action-controller)
* [x] [`exist_fragment?.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#exist-fragment-questionmark-action-controller)
* [x] [`start_processing.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#start-processing-action-controller)
* [x] [`process_action.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#process-action-action-controller)
* [x] [`send_file.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#send-file-action-controller)
* [x] [`send_data.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#send-data-action-controller)
* [x] [`redirect_to.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#redirect-to-action-controller)
* [x] [`halted_callback.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#halted-callback-action-controller)
* [x] [`unpermitted_parameters.action_controller`](https://guides.rubyonrails.org/active_support_instrumentation.html#unpermitted-parameters-action-controller)

### Action Dispatch

* [ ] [`process_middleware.action_dispatch`](https://guides.rubyonrails.org/active_support_instrumentation.html#process-middleware-action-dispatch)

### Action View

* [x] [`render_template.action_view`](https://guides.rubyonrails.org/active_support_instrumentation.html#render-template-action-view)
* [x] [`render_partial.action_view`](https://guides.rubyonrails.org/active_support_instrumentation.html#render-partial-action-view)
* [x] [`render_collection.action_view`](https://guides.rubyonrails.org/active_support_instrumentation.html#render-collection-action-view)

### Active Record

* [x] `strict_loading_violation.active_record` (Not yet documented. See the configuration of `action_on_strict_loading_violation`)
* [x] [`sql.active_record`](https://guides.rubyonrails.org/active_support_instrumentation.html#sql-active-record)
* [x] [`instantiation.active_record`](https://guides.rubyonrails.org/active_support_instrumentation.html#instantiation-active-record)

### Action Mailer

* [x] [`deliver.action_mailer`](https://guides.rubyonrails.org/active_support_instrumentation.html#deliver-action-mailer)
* [x] [`process.action_mailer`](https://guides.rubyonrails.org/active_support_instrumentation.html#process-action-mailer)

### Active Support

* [ ] [`cache_read.active_support`](https://guides.rubyonrails.org/active_support_instrumentation.html#cache-read-active-support)
* [ ] [`cache_generate.active_support`](https://guides.rubyonrails.org/active_support_instrumentation.html#cache-generate-active-support)
* [ ] [`cache_fetch_hit.active_support`](https://guides.rubyonrails.org/active_support_instrumentation.html#cache-fetch-hit-active-support)
* [ ] [`cache_write.active_support`](https://guides.rubyonrails.org/active_support_instrumentation.html#cache-write-active-support)
* [ ] [`cache_delete.active_support`](https://guides.rubyonrails.org/active_support_instrumentation.html#cache-delete-active-support)
* [ ] [`cache_exist?.active_support`](https://guides.rubyonrails.org/active_support_instrumentation.html#cache-exist-questionmark-active-support)

### Active Job

* [ ] [`enqueue_at.active_job`](https://guides.rubyonrails.org/active_support_instrumentation.html#enqueue-at-active-job)
* [ ] [`enqueue.active_job`](https://guides.rubyonrails.org/active_support_instrumentation.html#enqueue-active-job)
* [ ] [`enqueue_retry.active_job`](https://guides.rubyonrails.org/active_support_instrumentation.html#enqueue-retry-active-job)
* [ ] [`perform_start.active_job`](https://guides.rubyonrails.org/active_support_instrumentation.html#perform-start-active-job)
* [ ] [`perform.active_job`](https://guides.rubyonrails.org/active_support_instrumentation.html#perform-active-job)
* [ ] [`retry_stopped.active_job`](https://guides.rubyonrails.org/active_support_instrumentation.html#retry-stopped-active-job)
* [ ] [`discard.active_job`](https://guides.rubyonrails.org/active_support_instrumentation.html#discard-active-job)

### Action Cable

* [ ] [`perform_action.action_cable`](https://guides.rubyonrails.org/active_support_instrumentation.html#perform-action-action-cable)
* [ ] [`transmit.action_cable`](https://guides.rubyonrails.org/active_support_instrumentation.html#transmit-action-cable)
* [ ] [`transmit_subscription_confirmation.action_cable`](https://guides.rubyonrails.org/active_support_instrumentation.html#transmit-subscription-confirmation-action-cable)
* [ ] [`transmit_subscription_rejection.action_cable`](https://guides.rubyonrails.org/active_support_instrumentation.html#transmit-subscription-rejection-action-cable)
* [ ] [`broadcast.action_cable`](https://guides.rubyonrails.org/active_support_instrumentation.html#broadcast-action-cable)

### Active Storage

* [ ] [`service_upload.active_storage`](https://guides.rubyonrails.org/active_support_instrumentation.html#service-upload-active-storage)
* [ ] [`service_streaming_download.active_storage`](https://guides.rubyonrails.org/active_support_instrumentation.html#service-streaming-download-active-storage)
* [ ] [`service_download_chunk.active_storage`](https://guides.rubyonrails.org/active_support_instrumentation.html#service-download-chunk-active-storage)
* [ ] [`service_download.active_storage`](https://guides.rubyonrails.org/active_support_instrumentation.html#service-download-active-storage)
* [ ] [`service_delete.active_storage`](https://guides.rubyonrails.org/active_support_instrumentation.html#service-delete-active-storage)
* [ ] [`service_delete_prefixed.active_storage`](https://guides.rubyonrails.org/active_support_instrumentation.html#service-delete-prefixed-active-storage)
* [ ] [`service_exist.active_storage`](https://guides.rubyonrails.org/active_support_instrumentation.html#service-exist-active-storage)
* [ ] [`service_url.active_storage`](https://guides.rubyonrails.org/active_support_instrumentation.html#service-url-active-storage)
* [ ] [`service_update_metadata.active_storage`](https://guides.rubyonrails.org/active_support_instrumentation.html#service-update-metadata-active-storage)
* [ ] [`preview.active_storage`](https://guides.rubyonrails.org/active_support_instrumentation.html#preview-active-storage)
* [ ] [`analyze.active_storage`](https://edgeguides.rubyonrails.org/active_support_instrumentation.html#analyze-active-storage)

### Railties

* [ ] [`load_config_initializer.railties`](https://guides.rubyonrails.org/active_support_instrumentation.html#load-config-initializer-railties)

### Rails

* [ ] [`deprecation.rails`](https://guides.rubyonrails.org/active_support_instrumentation.html#deprecation-rails)

## Contributing

Contributing is welcome 😄 Please open a pull request!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
