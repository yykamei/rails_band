# frozen_string_literal: true

require 'test_helper'

class EnqueueRetryTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      'enqueue_retry.active_job': ->(event) { @event = event }
    }
  end

  def event_name
    'enqueue_retry.active_job'
  end

  def trigger_event
    FlakyJob.perform_now
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
