# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
  class CacheDeleteMatchedTest < ActionDispatch::IntegrationTest
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveSupport::LogSubscriber.consumers = {
        'cache_delete_matched.active_support': ->(event) { @event = event }
      }
    end

    def event_name
      'cache_delete_matched.active_support'
    end

    def trigger_event
      get '/users/123/cache4'
    end

    test 'calls #to_h' do
      get '/users/123/cache4'

      %i[name time end transaction_id cpu_time idle_time allocations duration key store].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      get '/users/123/cache4'

      assert_equal({ name: 'cache_delete_matched.active_support' }, @event.slice(:name))
    end

    test 'returns an instance of CacheDeleteMatched' do
      get '/users/123/cache4'

      assert_instance_of RailsBand::ActiveSupport::Event::CacheDeleteMatched, @event
    end

    test 'returns key' do
      get '/users/123/cache4'

      assert_equal 'MyDeleteMatched', @event.key
    end

    test 'returns store' do
      get '/users/123/cache4'

      assert_equal 'Store!', @event.store
    end
  end
end
