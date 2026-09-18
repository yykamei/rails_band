# frozen_string_literal: true

require 'test_helper'

if defined?(ActiveJob::Continuable)
  class StepSkippedTest < ActiveSupport::TestCase
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveJob::LogSubscriber.consumers = {
        'step_skipped.active_job': ->(event) { @event = event }
      }
    end

    def event_name
      'step_skipped.active_job'
    end

    # `step_skipped.active_job` is emitted when a Continuable job re-encounters
    # a step that has already been completed. Like a real queue adapter, the
    # interrupted job is serialized and deserialized before running again, so
    # that its completed steps replay and emit the event.
    def trigger_event
      interrupted = SkippedStepJob.new
      interrupted.perform_now
      resumed = SkippedStepJob.deserialize(interrupted.serialize)
      resumed.perform_now
    end

    test 'calls #to_h' do
      trigger_event

      %i[name time end transaction_id cpu_time idle_time allocations duration adapter job step].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      trigger_event

      assert_equal({ name: 'step_skipped.active_job' }, @event.slice(:name))
    end

    test 'returns an instance of StepSkipped' do
      trigger_event

      assert_instance_of RailsBand::ActiveJob::Event::StepSkipped, @event
    end

    test 'returns adapter' do
      trigger_event

      assert_instance_of ActiveJob::QueueAdapters::TestAdapter, @event.adapter
    end

    test 'returns job' do
      trigger_event

      assert_instance_of SkippedStepJob, @event.job
    end

    test 'returns the name of every skipped step' do
      events = []
      RailsBand::ActiveJob::LogSubscriber.consumers = {
        'step_skipped.active_job': ->(event) { events << event }
      }
      trigger_event

      assert_equal %i[first second], events.map(&:step)
    end
  end
end
