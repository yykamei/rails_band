# frozen_string_literal: true

require 'test_helper'

class DeprecationSubscriberTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
  end

  test 'use the consumer with the exact event name' do # rubocop:disable Minitest/MultipleAssertions
    RailsBand::DeprecationSubscriber.consumers = {
      'deprecation.rails': ->(event) { @event = event }
    }
    get '/users/1/deprecation'

    assert_match(/DEPRECATION WARNING: deprecated!!!/, @event.message)
    assert_equal 'Rails', @event.gem_name
    assert_instance_of String, @event.deprecation_horizon
    @event.callstack.each do |location|
      assert_instance_of Thread::Backtrace::Location, location
    end
  end

  test 'use the consumer with namespace' do # rubocop:disable Minitest/MultipleAssertions
    RailsBand::DeprecationSubscriber.consumers = {
      deprecation: ->(event) { @event = event }
    }
    get '/users/1/deprecation'

    assert_match(/DEPRECATION WARNING: deprecated!!!/, @event.message)
    assert_equal 'Rails', @event.gem_name
    assert_instance_of String, @event.deprecation_horizon
    @event.callstack.each do |location|
      assert_instance_of Thread::Backtrace::Location, location
    end
  end

  test 'use the consumer with default' do # rubocop:disable Minitest/MultipleAssertions
    RailsBand::DeprecationSubscriber.consumers = {
      default: ->(event) { @event = event }
    }
    get '/users/1/deprecation'

    assert_match(/DEPRECATION WARNING: deprecated!!!/, @event.message)
    assert_equal 'Rails', @event.gem_name
    assert_instance_of String, @event.deprecation_horizon
    @event.callstack.each do |location|
      assert_instance_of Thread::Backtrace::Location, location
    end
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::DeprecationSubscriber.consumers = {
      'unknown.rails': ->(event) { @event = event }
    }
    get '/users/1/deprecation'

    assert_nil @event
  end
end
