# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
  class CacheDeleteMultiTest < ActionDispatch::IntegrationTest
    setup do
      @event = nil
      RailsBand::ActiveSupport::LogSubscriber.consumers = {
        'cache_delete_multi.active_support': ->(event) { @event = event }
      }
    end

    test 'returns name' do
      get '/users/123/cache3'
      assert_equal 'cache_delete_multi.active_support', @event.name
    end

    test 'returns time' do
      get '/users/123/cache3'
      assert_instance_of Float, @event.time
    end

    test 'returns end' do
      get '/users/123/cache3'
      assert_instance_of Float, @event.end
    end

    test 'returns transaction_id' do
      get '/users/123/cache3'
      assert_instance_of String, @event.transaction_id
    end

    test 'returns children' do
      get '/users/123/cache3'
      assert_instance_of Array, @event.children
    end

    test 'returns cpu_time' do
      get '/users/123/cache3'
      assert_instance_of Float, @event.cpu_time
    end

    test 'returns idle_time' do
      get '/users/123/cache3'
      assert_instance_of Float, @event.idle_time
    end

    test 'returns allocations' do
      get '/users/123/cache3'
      assert_instance_of Integer, @event.allocations
    end

    test 'returns duration' do
      get '/users/123/cache3'
      assert_instance_of Float, @event.duration
    end

    test 'calls #to_h' do
      get '/users/123/cache3'
      %i[name time end transaction_id children cpu_time idle_time allocations duration key].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      get '/users/123/cache3'
      assert_equal({ name: 'cache_delete_multi.active_support' }, @event.slice(:name))
    end

    test 'returns an instance of CacheDeleteMulti' do
      get '/users/123/cache3'
      assert_instance_of RailsBand::ActiveSupport::Event::CacheDeleteMulti, @event
    end

    test 'returns key' do
      get '/users/123/cache3'
      assert_equal %w[ok df], @event.key
    end

    test 'returns store' do
      get '/users/123/cache3'
      assert_equal 'ActiveSupport::Cache::NullStore', @event.store
    end
  end
end