# frozen_string_literal: true

require 'test_helper'

class HaltedCallbackTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'halted_callback.action_controller': ->(event) { @event = event }
    }
  end

  def event_name
    'halted_callback.action_controller'
  end

  def trigger_event
    get '/users/123/callback'
  end

  test 'calls #to_h' do
    get '/users/123/callback'

    %i[name time end transaction_id cpu_time idle_time allocations duration filter].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users/123/callback'

    assert_equal({ name: 'halted_callback.action_controller', filter: :halt! }, @event.slice(:name, :filter))
  end

  test 'returns an instance of HaltedCallback' do
    get '/users/123/callback'

    assert_instance_of RailsBand::ActionController::Event::HaltedCallback, @event
  end

  test 'returns filter' do
    get '/users/123/callback'

    assert_equal :halt!, @event.filter
  end
end
