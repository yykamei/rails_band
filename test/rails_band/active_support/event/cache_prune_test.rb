# frozen_string_literal: true

require 'test_helper'

class CachePruneTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      'cache_prune.active_support': ->(event) { @event = event }
    }
  end

  def event_name
    'cache_prune.active_support'
  end

  def trigger_event
    get '/users/123/cache4'
  end

  test 'calls #to_h' do
    get '/users/123/cache4'

    %i[name time end transaction_id cpu_time idle_time allocations duration store key from].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users/123/cache4'

    assert_equal({ name: 'cache_prune.active_support' }, @event.slice(:name))
  end

  test 'returns an instance of CachePrune' do
    get '/users/123/cache4'

    assert_instance_of RailsBand::ActiveSupport::Event::CachePrune, @event
  end

  test 'returns store' do
    get '/users/123/cache4'

    assert_equal 'Store!', @event.store
  end

  test 'returns key' do
    get '/users/123/cache4'

    assert_equal 5000, @event.key
  end
  test 'returns from' do
    get '/users/123/cache4'

    assert_equal 9001, @event.from
  end
end
