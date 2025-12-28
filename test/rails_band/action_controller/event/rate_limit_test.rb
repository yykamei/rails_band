# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('7.2')
  class RateLimitTest < ActionDispatch::IntegrationTest
    setup do
      @event = nil
      RailsBand::ActionController::LogSubscriber.consumers = {
        'rate_limit.action_controller': ->(event) { @event = event }
      }
      RateLimitedController.cache_store.clear
    end

    test 'returns name' do
      trigger_rate_limit

      assert_equal 'rate_limit.action_controller', @event.name
    end

    test 'returns time' do
      trigger_rate_limit

      assert_instance_of Float, @event.time
    end

    test 'returns end' do
      trigger_rate_limit

      assert_instance_of Float, @event.end
    end

    test 'returns transaction_id' do
      trigger_rate_limit

      assert_instance_of String, @event.transaction_id
    end

    test 'returns cpu_time' do
      trigger_rate_limit

      assert_instance_of Float, @event.cpu_time
    end

    test 'returns idle_time' do
      trigger_rate_limit

      assert_instance_of Float, @event.idle_time
    end

    test 'returns allocations' do
      trigger_rate_limit

      assert_instance_of Integer, @event.allocations
    end

    test 'returns duration' do
      trigger_rate_limit

      assert_instance_of Float, @event.duration
    end

    test 'calls #to_h' do
      trigger_rate_limit

      base_keys = %i[name time end transaction_id cpu_time idle_time allocations duration request]

      base_keys.each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      trigger_rate_limit

      assert_equal({ name: 'rate_limit.action_controller' }, @event.slice(:name))
    end

    test 'returns an instance of RateLimit' do
      trigger_rate_limit

      assert_instance_of RailsBand::ActionController::Event::RateLimit, @event
    end

    test 'returns request' do
      trigger_rate_limit

      assert_instance_of ActionDispatch::Request, @event.request
    end

    if Gem::Version.new(Rails.version) >= Gem::Version.new('8.1.0.alpha')
      test 'calls #to_h with extended payload' do
        trigger_rate_limit

        %i[count to within by rate_limit_name scope cache_key].each do |key|
          assert_includes @event.to_h, key
        end
      end

      test 'returns count' do
        trigger_rate_limit

        assert_equal 3, @event.count
      end

      test 'returns to' do
        trigger_rate_limit

        assert_equal 2, @event.to
      end

      test 'returns within' do
        trigger_rate_limit

        assert_equal 2.seconds, @event.within
      end

      test 'returns by' do
        trigger_rate_limit

        assert_equal '127.0.0.1', @event.by
      end

      test 'returns rate_limit_name' do
        trigger_rate_limit

        assert_equal 'test-limit', @event.rate_limit_name
      end

      test 'returns scope' do
        trigger_rate_limit

        assert_equal 'rate_limited', @event.scope
      end

      test 'returns cache_key' do
        trigger_rate_limit

        assert_equal 'rate-limit:rate_limited:test-limit:127.0.0.1', @event.cache_key
      end
    end

    private

    def trigger_rate_limit
      get '/rate_limited'
      get '/rate_limited'
      begin
        get '/rate_limited'
      rescue ActionController::TooManyRequests
        # Expected exception
      end
    end
  end
end
