# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1')
  class MessageSerializerFallbackTest < ActionDispatch::IntegrationTest
    setup do
      @event = nil
      RailsBand::ActiveSupport::LogSubscriber.consumers = {
        'message_serializer_fallback.active_support': ->(event) { @event = event }
      }
    end

    test 'returns name' do
      get '/users/123/message_serializer_fallback'

      assert_equal 'message_serializer_fallback.active_support', @event.name
    end

    test 'returns time' do
      get '/users/123/message_serializer_fallback'

      assert_instance_of Float, @event.time
    end

    test 'returns end' do
      get '/users/123/message_serializer_fallback'

      assert_instance_of Float, @event.end
    end

    test 'returns transaction_id' do
      get '/users/123/message_serializer_fallback'

      assert_instance_of String, @event.transaction_id
    end

    test 'returns cpu_time' do
      get '/users/123/message_serializer_fallback'

      assert_instance_of Float, @event.cpu_time
    end

    test 'returns idle_time' do
      get '/users/123/message_serializer_fallback'

      assert_instance_of Float, @event.idle_time
    end

    test 'returns allocations' do
      get '/users/123/message_serializer_fallback'

      assert_instance_of Integer, @event.allocations
    end

    test 'returns duration' do
      get '/users/123/message_serializer_fallback'

      assert_instance_of Float, @event.duration
    end

    test 'calls #to_h' do
      get '/users/123/message_serializer_fallback'

      %i[name time end transaction_id cpu_time idle_time allocations duration serializer fallback serialized
         deserialized].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      get '/users/123/message_serializer_fallback'

      assert_equal({ name: 'message_serializer_fallback.active_support' }, @event.slice(:name))
    end

    test 'returns an instance of MessageSerializerFallback' do
      get '/users/123/message_serializer_fallback'

      assert_instance_of RailsBand::ActiveSupport::Event::MessageSerializerFallback, @event
    end

    test 'returns serializer' do
      get '/users/123/message_serializer_fallback'

      assert_equal :marshal, @event.serializer
    end

    test 'returns fallback' do
      get '/users/123/message_serializer_fallback'

      assert_equal :json, @event.fallback
    end

    test 'returns serialized' do
      get '/users/123/message_serializer_fallback'

      assert_equal '{"foo":"bar"}', @event.serialized
    end

    test 'returns deserialized' do
      get '/users/123/message_serializer_fallback'

      assert_equal({ 'foo' => 'bar' }, @event.deserialized)
    end
  end
end
