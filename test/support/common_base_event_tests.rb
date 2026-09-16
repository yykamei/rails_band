# frozen_string_literal: true

# Common test cases for the attributes that every event inherits from RailsBand::BaseEvent.
#
# Include this module in an event test class (e.g. under test/rails_band/*/event/) to share
# the assertions for the BaseEvent contract, instead of duplicating them in every file.
#
# Including classes must provide:
# - @event: the event object, assigned by the consumer registered in setup.
# - #event_name: returns the expected event name.
# - #trigger_event: fires the instrumentation event under test.
#
# @example
#   class ProcessActionTest < ActionDispatch::IntegrationTest
#     include CommonBaseEventTests
#
#     setup do
#       @event = nil
#       RailsBand::ActionController::LogSubscriber.consumers = {
#         'process_action.action_controller': ->(event) { @event = event }
#       }
#     end
#
#     def event_name
#       'process_action.action_controller'
#     end
#
#     def trigger_event
#       get '/users'
#     end
#   end
module CommonBaseEventTests
  def test_returns_name
    trigger_event

    assert_equal event_name, @event.name
  end

  def test_returns_time
    trigger_event

    assert_instance_of Float, @event.time
  end

  def test_returns_end
    trigger_event

    assert_instance_of Float, @event.end
  end

  def test_returns_transaction_id
    trigger_event

    assert_instance_of String, @event.transaction_id
  end

  def test_returns_cpu_time
    trigger_event

    assert_instance_of Float, @event.cpu_time
  end

  def test_returns_idle_time
    trigger_event

    assert_instance_of Float, @event.idle_time
  end

  def test_returns_allocations
    trigger_event

    assert_instance_of Integer, @event.allocations
  end

  def test_returns_duration
    trigger_event

    assert_instance_of Float, @event.duration
  end
end
