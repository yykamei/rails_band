# frozen_string_literal: true

require 'test_helper'

class CacheReadMultiTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      'cache_read_multi.active_support': ->(event) { @event = event }
    }
  end

  def event_name
    'cache_read_multi.active_support'
  end

  def trigger_event
    get '/users/123/cache2'
  end

  test 'calls #to_h' do
    get '/users/123/cache2'

    %i[name time end transaction_id cpu_time idle_time allocations duration key hits super_operation].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users/123/cache2'

    assert_equal({ name: 'cache_read_multi.active_support' }, @event.slice(:name))
  end

  test 'returns an instance of CacheReadMulti' do
    get '/users/123/cache2'

    assert_instance_of RailsBand::ActiveSupport::Event::CacheReadMulti, @event
  end

  test 'returns key' do
    get '/users/123/cache2'

    assert_equal %w[a b c], @event.key
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

  test 'returns hits' do
    get '/users/123/cache2'

    assert_equal [], @event.hits
  end

  test 'returns super_operation' do
    get '/users/123/cache2'

    assert_equal :fetch_multi, @event.super_operation
  end
end
