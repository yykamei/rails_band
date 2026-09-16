# frozen_string_literal: true

require 'test_helper'

class CacheDecrementTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      'cache_decrement.active_support': ->(event) { @event = event }
    }
  end

  def event_name
    'cache_decrement.active_support'
  end

  def trigger_event
    get '/users/123/cache4'
  end

  test 'calls #to_h' do
    get '/users/123/cache4'

    %i[name time end transaction_id cpu_time idle_time allocations duration key store amount].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users/123/cache4'

    assert_equal({ name: 'cache_decrement.active_support' }, @event.slice(:name))
  end

  test 'returns an instance of CacheDecrement' do
    get '/users/123/cache4'

    assert_instance_of RailsBand::ActiveSupport::Event::CacheDecrement, @event
  end

  test 'returns key' do
    get '/users/123/cache4'

    assert_equal('DEC1', @event.key)
  end

  test 'returns store' do
    get '/users/123/cache4'

    assert_equal 'RedisCacheStore', @event.store
  end

  test 'returns amount' do
    get '/users/123/cache4'

    assert_equal 1, @event.amount
  end
end
