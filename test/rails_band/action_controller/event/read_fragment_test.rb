# frozen_string_literal: true

require 'test_helper'

class ReadFragmentTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'read_fragment.action_controller': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get '/users'
    assert_equal 'read_fragment.action_controller', @event.name
  end

  test 'returns time' do
    get '/users'
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    get '/users'
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    get '/users'
    assert_instance_of String, @event.transaction_id
  end

  test 'returns children' do
    get '/users'
    assert_instance_of Array, @event.children
  end

  test 'returns cpu_time' do
    get '/users'
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    get '/users'
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    get '/users'
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    get '/users'
    assert_instance_of Float, @event.duration
  end

  test 'returns an instance of ReadFragmentTest' do
    get '/users'
    assert_instance_of RailsBand::ActionController::Event::ReadFragment, @event
  end

  test 'returns the cache key' do
    get '/users'
    assert_respond_to @event, :key
  end
end
