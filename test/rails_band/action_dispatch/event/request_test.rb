# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1.0')
  class RequestTest < ActionDispatch::IntegrationTest
    setup do
      @event = nil
      RailsBand::ActionDispatch::LogSubscriber.consumers = {
        'request.action_dispatch': ->(event) { @event = event }
      }
    end

    test 'returns name' do
      get '/old_users'

      assert_equal 'request.action_dispatch', @event.name
    end

    test 'returns time' do
      get '/old_users'

      assert_instance_of Float, @event.time
    end

    test 'returns end' do
      get '/old_users'

      assert_instance_of Float, @event.end
    end

    test 'returns transaction_id' do
      get '/old_users'

      assert_instance_of String, @event.transaction_id
    end

    test 'returns cpu_time' do
      get '/old_users'

      assert_instance_of Float, @event.cpu_time
    end

    test 'returns idle_time' do
      get '/old_users'

      assert_instance_of Float, @event.idle_time
    end

    test 'returns allocations' do
      get '/old_users'

      assert_instance_of Integer, @event.allocations
    end

    test 'returns duration' do
      get '/old_users'

      assert_instance_of Float, @event.duration
    end

    test 'calls #to_h' do
      get '/old_users'

      %i[name time end transaction_id cpu_time idle_time allocations duration request].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      get '/old_users'

      assert_equal({ name: 'request.action_dispatch' }, @event.slice(:name))
    end

    test 'returns an instance of Request' do
      get '/old_users'

      assert_instance_of RailsBand::ActionDispatch::Event::Request, @event
    end

    test 'returns the request' do
      get '/old_users'

      assert_kind_of ::ActionDispatch::Request, @event.request
    end
  end
end
