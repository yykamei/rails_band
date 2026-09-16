# frozen_string_literal: true

require 'test_helper'

class DiscardTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      'discard.active_job': ->(event) { @event = event }
    }
  end

  def event_name
    'discard.active_job'
  end

  def trigger_event
    # Job-related Error may raise while the enqueued job runs; swallow it so that
    # the assertions shared via CommonBaseEventTests run after this trigger.
    perform_enqueued_jobs do
      DiscardJob.perform_later
    rescue DiscardJob::Error
      nil
    end
  end

  test 'calls #to_h' do
    perform_enqueued_jobs do
      DiscardJob.perform_later
    rescue DiscardJob::Error
      %i[name time end transaction_id cpu_time idle_time allocations duration adapter job error].each do |key|
        assert_includes @event.to_h, key
      end
    end
  end

  test 'calls #slice' do
    perform_enqueued_jobs do
      DiscardJob.perform_later
    rescue DiscardJob::Error
      assert_equal({ name: 'discard.active_job' }, @event.slice(:name))
    end
  end

  test 'returns an instance of Discard' do
    perform_enqueued_jobs do
      DiscardJob.perform_later
    rescue DiscardJob::Error
      assert_instance_of RailsBand::ActiveJob::Event::Discard, @event
    end
  end

  test 'returns adapter' do
    perform_enqueued_jobs do
      DiscardJob.perform_later
    rescue DiscardJob::Error
      assert_instance_of ::ActiveJob::QueueAdapters::TestAdapter, @event.adapter
    end
  end

  test 'returns job' do
    perform_enqueued_jobs do
      DiscardJob.perform_later
    rescue DiscardJob::Error
      assert_instance_of DiscardJob, @event.job
      assert_equal [], @event.job.arguments
    end
  end

  test 'returns error' do
    perform_enqueued_jobs do
      DiscardJob.perform_later
    rescue DiscardJob::Error
      assert_instance_of DiscardJob::Error, @event.error
    end
  end
end
