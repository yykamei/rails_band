# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('7.2.0.alpha')
  class SendStreamTest < ActionDispatch::IntegrationTest
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActionController::LogSubscriber.consumers = {
        'send_stream.action_controller': ->(event) { @event = event }
      }
    end

    def event_name
      'send_stream.action_controller'
    end

    def trigger_event
      get '/special_stream'
    end

    test 'calls #to_h' do
      get '/special_stream'

      %i[name time end transaction_id cpu_time idle_time allocations duration
         filename type disposition].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      get '/special_stream'

      assert_equal({ name: 'send_stream.action_controller' }, @event.slice(:name))
    end

    test 'returns an instance of SendStream' do
      get '/special_stream'

      assert_instance_of RailsBand::ActionController::Event::SendStream, @event
    end

    test 'returns filename' do
      get '/special_stream'

      assert_equal 'special.txt', @event.filename
    end

    test 'returns type' do
      get '/special_stream'

      assert_nil @event.type
    end

    test 'returns disposition' do
      get '/special_stream'

      assert_equal 'attachment', @event.disposition
    end
  end
end
