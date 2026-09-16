# frozen_string_literal: true

require 'test_helper'

class CacheWriteMultiTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      'cache_write_multi.active_support': ->(event) { @event = event }
    }
  end

  def event_name
    'cache_write_multi.active_support'
  end

  def trigger_event
    get '/users/123/cache3'
  end

  test 'calls #to_h' do
    get '/users/123/cache3'

    %i[name time end transaction_id cpu_time idle_time allocations duration key].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users/123/cache3'

    assert_equal({ name: 'cache_write_multi.active_support' }, @event.slice(:name))
  end

  test 'returns an instance of CacheWriteMulti' do
    get '/users/123/cache3'

    assert_instance_of RailsBand::ActiveSupport::Event::CacheWriteMulti, @event
  end

  test 'returns key' do
    get '/users/123/cache3'

    assert_equal({ w1: 1, w2: 2 }, @event.key.transform_keys(&:to_sym))
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
    test 'returns store' do
      get '/users/123/cache3'

      assert_equal 'ActiveSupport::Cache::NullStore', @event.store
    end
  else
    test 'raises NoMethodError when accessing store' do
      get '/users/123/cache3'
      assert_raises NoMethodError do
        @event.store
      end
    end
  end
end
