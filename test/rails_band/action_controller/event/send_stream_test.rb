# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('7.2.0.alpha')
  class SendStreamTest < ActionDispatch::IntegrationTest
    setup do
      @event = nil
      RailsBand::ActionController::LogSubscriber.consumers = {
        'send_stream.action_controller': ->(event) { @event = event }
      }
    end

    test 'returns name' do
      get '/special_stream'

      assert_equal 'send_stream.action_controller', @event.name
    end

    test 'returns time' do
      get '/special_stream'

      assert_instance_of Float, @event.time
    end

    test 'returns end' do
      get '/special_stream'

      assert_instance_of Float, @event.end
    end

    test 'returns transaction_id' do
      get '/special_stream'

      assert_instance_of String, @event.transaction_id
    end

    test 'returns cpu_time' do
      get '/special_stream'

      assert_instance_of Float, @event.cpu_time
    end

    test 'returns idle_time' do
      get '/special_stream'

      assert_instance_of Float, @event.idle_time
    end

    test 'returns allocations' do
      get '/special_stream'

      assert_instance_of Integer, @event.allocations
    end

    test 'returns duration' do
      get '/special_stream'

      assert_instance_of Float, @event.duration
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
