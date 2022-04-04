# frozen_string_literal: true

require 'test_helper'

class RetryStoppedTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      'retry_stopped.active_job': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_equal 'retry_stopped.active_job', @event.name
    end
  end

  test 'returns time' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of Float, @event.time
    end
  end

  test 'returns end' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of Float, @event.end
    end
  end

  test 'returns transaction_id' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of String, @event.transaction_id
    end
  end

  test 'returns cpu_time' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of Float, @event.cpu_time
    end
  end

  test 'returns idle_time' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of Float, @event.idle_time
    end
  end

  test 'returns allocations' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of Integer, @event.allocations
    end
  end

  test 'returns duration' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of Float, @event.duration
    end
  end

  test 'calls #to_h' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      %i[name time end transaction_id cpu_time idle_time allocations duration adapter job error].each do |key|
        assert_includes @event.to_h, key
      end
    end
  end

  test 'calls #slice' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_equal({ name: 'retry_stopped.active_job' }, @event.slice(:name))
    end
  end

  test 'returns an instance of RetryStopped' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of RailsBand::ActiveJob::Event::RetryStopped, @event
    end
  end

  test 'returns adapter' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of ::ActiveJob::QueueAdapters::TestAdapter, @event.adapter
    end
  end

  test 'returns job' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of FlakyJob, @event.job
      assert_equal [], @event.job.arguments
    end
  end

  test 'returns error' do
    perform_enqueued_jobs do
      FlakyJob.perform_later
    rescue FlakyJob::Error
      assert_instance_of FlakyJob::Error, @event.error
    end
  end
end
