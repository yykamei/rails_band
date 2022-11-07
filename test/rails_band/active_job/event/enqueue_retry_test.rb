# frozen_string_literal: true

require 'test_helper'

class EnqueueRetryTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      'enqueue_retry.active_job': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    FlakyJob.perform_now

    assert_equal 'enqueue_retry.active_job', @event.name
  end

  test 'returns time' do
    FlakyJob.perform_now

    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    FlakyJob.perform_now

    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    FlakyJob.perform_now

    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    FlakyJob.perform_now

    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    FlakyJob.perform_now

    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    FlakyJob.perform_now

    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    FlakyJob.perform_now

    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    FlakyJob.perform_now

    %i[name time end transaction_id cpu_time idle_time allocations duration adapter job
       wait error].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    FlakyJob.perform_now

    assert_equal({ name: 'enqueue_retry.active_job' }, @event.slice(:name))
  end

  test 'returns an instance of EnqueueRetry' do
    FlakyJob.perform_now

    assert_instance_of RailsBand::ActiveJob::Event::EnqueueRetry, @event
  end

  test 'returns adapter' do
    FlakyJob.perform_now

    assert_instance_of ::ActiveJob::QueueAdapters::TestAdapter, @event.adapter
  end

  test 'returns job' do
    FlakyJob.perform_now

    assert_instance_of FlakyJob, @event.job
    assert_equal [], @event.job.arguments
  end

  test 'returns wait' do
    FlakyJob.perform_now

    assert_kind_of Numeric, @event.wait
  end

  test 'returns error' do
    FlakyJob.perform_now

    assert_instance_of FlakyJob::Error, @event.error
  end
end
