# frozen_string_literal: true

require 'test_helper'

class HaltedCallbackTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'halted_callback.action_controller': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    get '/users/123/callback'
    assert_equal 'halted_callback.action_controller', @event.name
  end

  test 'returns time' do
    get '/users/123/callback'
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    get '/users/123/callback'
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    get '/users/123/callback'
    assert_instance_of String, @event.transaction_id
  end

  test 'returns children' do
    get '/users/123/callback'
    assert_instance_of Array, @event.children
  end

  test 'returns cpu_time' do
    get '/users/123/callback'
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    get '/users/123/callback'
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    get '/users/123/callback'
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    get '/users/123/callback'
    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    get '/users/123/callback'
    %i[name time end transaction_id children cpu_time idle_time allocations duration filter].each do |key|
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
