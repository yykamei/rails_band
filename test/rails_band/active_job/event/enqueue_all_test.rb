# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1.0.alpha')
  class EnqueueAllTest < ActionDispatch::IntegrationTest
    setup do
      @event = nil
      RailsBand::ActiveJob::LogSubscriber.consumers = {
        'enqueue_all.active_job': ->(event) { @event = event }
      }
    end

    test 'returns name' do
      get '/yay/123'

      assert_equal 'enqueue_all.active_job', @event.name
    end

    test 'returns time' do
      get '/yay/123'

      assert_instance_of Float, @event.time
    end

    test 'returns end' do
      get '/yay/123'

      assert_instance_of Float, @event.end
    end

    test 'returns transaction_id' do
      get '/yay/123'

      assert_instance_of String, @event.transaction_id
    end

    test 'returns cpu_time' do
      get '/yay/123'

      assert_instance_of Float, @event.cpu_time
    end

    test 'returns idle_time' do
      get '/yay/123'

      assert_instance_of Float, @event.idle_time
    end

    test 'returns allocations' do
      get '/yay/123'

      assert_instance_of Integer, @event.allocations
    end

    test 'returns duration' do
      get '/yay/123'

      assert_instance_of Float, @event.duration
    end

    test 'calls #to_h' do
      get '/yay/123'

      %i[name time end transaction_id cpu_time idle_time allocations duration adapter jobs].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      get '/yay/123'

      assert_equal({ name: 'enqueue_all.active_job' }, @event.slice(:name))
    end

    test 'returns an instance of EnqueueAll' do
      get '/yay/123'

      assert_instance_of RailsBand::ActiveJob::Event::EnqueueAll, @event
    end

    test 'returns adapter' do
      get '/yay/123'

      assert_instance_of ::ActiveJob::QueueAdapters::TestAdapter, @event.adapter
    end

    test 'returns jobs' do
      get '/yay/123'

      assert_instance_of Array, @event.jobs
      assert_instance_of YayJob, @event.jobs.first
      assert_equal [[{ name: 'F!', message: 'This is F.' }]], @event.jobs.map(&:arguments)
    end
  end
end
