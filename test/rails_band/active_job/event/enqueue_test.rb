# frozen_string_literal: true

require 'test_helper'

class EnqueueTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      'enqueue.active_job': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    get '/yay/123'
    assert_equal 'enqueue.active_job', @event.name
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
    %i[name time end transaction_id cpu_time idle_time allocations duration adapter job].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/yay/123'
    assert_equal({ name: 'enqueue.active_job' }, @event.slice(:name))
  end

  test 'returns an instance of Enqueue' do
    get '/yay/123'
    assert_instance_of RailsBand::ActiveJob::Event::Enqueue, @event
  end

  test 'returns adapter' do
    get '/yay/123'
    assert_instance_of ::ActiveJob::QueueAdapters::TestAdapter, @event.adapter
  end

  test 'returns job' do
    get '/yay/123'
    assert_instance_of YayJob, @event.job
    assert_equal [{ name: 'E!', message: 'This is E.' }], @event.job.arguments
  end

  if Gem::Version.new(Rails.version) > Gem::Version.new('7.0')
    test 'returns aborted' do
      get '/yay/123?aborted=true'
      assert @event.aborted
    end
  end
end
