# frozen_string_literal: true

require 'test_helper'

class CacheWriteMultiTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      'cache_write_multi.active_support': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    get '/users/123/cache2'
    assert_equal 'cache_write_multi.active_support', @event.name
  end

  test 'returns time' do
    get '/users/123/cache2'
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    get '/users/123/cache2'
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    get '/users/123/cache2'
    assert_instance_of String, @event.transaction_id
  end

  test 'returns children' do
    get '/users/123/cache2'
    assert_instance_of Array, @event.children
  end

  test 'returns cpu_time' do
    get '/users/123/cache2'
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    get '/users/123/cache2'
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    get '/users/123/cache2'
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    get '/users/123/cache2'
    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    get '/users/123/cache2'
    %i[name time end transaction_id children cpu_time idle_time allocations duration key].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users/123/cache2'
    assert_equal({ name: 'cache_write_multi.active_support' }, @event.slice(:name))
  end

  test 'returns an instance of CacheWriteMulti' do
    get '/users/123/cache2'
    assert_instance_of RailsBand::ActiveSupport::Event::CacheWriteMulti, @event
  end

  test 'returns key' do
    get '/users/123/cache2'
    assert_equal({ w1: 1, w2: 2 }, @event.key)
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
    test 'returns store' do
      get '/users/123/cache2'
      assert_equal 'ActiveSupport::Cache::NullStore', @event.store
    end
  else
    test 'raises NoMethodError when accessing store' do
      get '/users/123/cache2'
      assert_raises NoMethodError do
        @event.store
      end
    end
  end
end
