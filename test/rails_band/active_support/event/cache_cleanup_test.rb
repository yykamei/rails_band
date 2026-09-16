# frozen_string_literal: true

require 'test_helper'

class CacheCleanupTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      'cache_cleanup.active_support': ->(event) { @event = event }
    }
  end

  def event_name
    'cache_cleanup.active_support'
  end

  def trigger_event
    get '/users/123/cache4'
  end

  test 'calls #to_h' do
    get '/users/123/cache4'

    %i[name time end transaction_id cpu_time idle_time allocations duration store size].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users/123/cache4'

    assert_equal({ name: 'cache_cleanup.active_support' }, @event.slice(:name))
  end

  test 'returns an instance of CacheCleanup' do
    get '/users/123/cache4'

    assert_instance_of RailsBand::ActiveSupport::Event::CacheCleanup, @event
  end

  test 'returns size' do
    get '/users/123/cache4'

    assert_equal 2, @event.size
  end

  test 'returns store' do
    get '/users/123/cache4'

    assert_equal 'Store!', @event.store
  end
end
