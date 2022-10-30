# frozen_string_literal: true

require 'test_helper'

class ProcessMiddlewareTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionDispatch::LogSubscriber.consumers = {
      'process_middleware.action_dispatch': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get '/users'

    assert_equal 'process_middleware.action_dispatch', @event.name
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

  test 'calls #to_h' do
    get '/users'
    %i[name time end transaction_id cpu_time idle_time allocations duration middleware].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users'

    assert_equal({ name: 'process_middleware.action_dispatch' }, @event.slice(:name))
  end

  test 'returns an instance of ProcessMiddleware' do
    get '/users'

    assert_instance_of RailsBand::ActionDispatch::Event::ProcessMiddleware, @event
  end

  test 'returns the middleware' do
    get '/users'

    assert_respond_to @event, :middleware
  end
end
