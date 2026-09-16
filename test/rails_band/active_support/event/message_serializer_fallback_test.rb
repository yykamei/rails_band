# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1')
  class MessageSerializerFallbackTest < ActionDispatch::IntegrationTest
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveSupport::LogSubscriber.consumers = {
        'message_serializer_fallback.active_support': ->(event) { @event = event }
      }
    end

    def event_name
      'message_serializer_fallback.active_support'
    end

    def trigger_event
      get '/users/123/message_serializer_fallback'
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
