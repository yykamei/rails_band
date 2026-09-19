# frozen_string_literal: true

require 'test_helper'

class RailtiesLogSubscriberTest < ActiveSupport::TestCase
  setup do
    @event = nil
    RailsBand::Railties::LogSubscriber.consumers = {
      'load_config_initializer.railties': ->(event) { @event = event }
    }
  end

  test 'use the consumer with the exact event name' do
    trigger_event

    assert_instance_of RailsBand::Railties::Event::LoadConfigInitializer, @event
    assert_instance_of String, @event.initializer
  end

  test 'use the consumer with namespace' do
    RailsBand::Railties::LogSubscriber.consumers = {
      railties: ->(event) { @event = event }
    }
    trigger_event

    assert_instance_of RailsBand::Railties::Event::LoadConfigInitializer, @event
    assert_instance_of String, @event.initializer
  end

  test 'use the consumer with default' do
    RailsBand::Railties::LogSubscriber.consumers = {
      default: ->(event) { @event = event }
    }
    trigger_event

    assert_instance_of RailsBand::Railties::Event::LoadConfigInitializer, @event
    assert_instance_of String, @event.initializer
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::Railties::LogSubscriber.consumers = {
      'unknown.railties': ->(event) { @event = event }
    }
    trigger_event

    assert_nil @event
  end

  private

  # The event itself is emitted only once during Rails boot, which has already happened
  # before tests run. Hence, tests re-emit the same event to exercise the subscriber.
  def trigger_event
    ActiveSupport::Notifications.instrument('load_config_initializer.railties', initializer: 'foo.rb') { nil }
  end
end
