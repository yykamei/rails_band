# frozen_string_literal: true

require 'test_helper'

class LoadConfigInitializerTest < ActiveSupport::TestCase
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::Railties::LogSubscriber.consumers = {
      'load_config_initializer.railties': ->(event) { @event = event }
    }
  end

  def event_name
    'load_config_initializer.railties'
  end

  # The event itself is emitted only once during Rails boot, which has already happened
  # before tests run. Hence, tests re-emit the same event to exercise the event object.
  def trigger_event
    ActiveSupport::Notifications.instrument('load_config_initializer.railties', initializer: 'foo.rb') { nil }
  end

  test 'returns initializer' do
    trigger_event

    assert_instance_of String, @event.initializer
  end
end
