# frozen_string_literal: true

require 'test_helper'

class ExpireFragmentTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'expire_fragment.action_controller': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get '/users'

    assert_equal 'expire_fragment.action_controller', @event.name
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
    %i[name time end transaction_id cpu_time idle_time allocations duration key].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users'

    assert_equal({ name: 'expire_fragment.action_controller' }, @event.slice(:name))
  end

  test 'returns an instance of ExpireFragment' do
    get '/users'

    assert_instance_of RailsBand::ActionController::Event::ExpireFragment, @event
  end

  test 'returns the cache key' do
    get '/users'

    assert_respond_to @event, :key
  end
end
