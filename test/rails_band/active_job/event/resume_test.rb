# frozen_string_literal: true

require 'test_helper'

if defined?(ActiveJob::Continuable)
  class ResumeTest < ActiveSupport::TestCase
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveJob::LogSubscriber.consumers = {
        'resume.active_job': ->(event) { @event = event }
      }
      InterruptJob.runs = 0
    end

    def event_name
      'resume.active_job'
    end

    # `resume.active_job` is emitted when a Continuable job that has already
    # started runs again after being interrupted. Like a real queue adapter,
    # the interrupted job is serialized and deserialized before running again.
    # The last run replays fully completed steps, emitting the event with
    # every step completed and no current step.
    def trigger_event
      interrupted = InterruptJob.new
      interrupted.perform_now
      resumed = InterruptJob.deserialize(interrupted.serialize)
      resumed.perform_now
      completed = InterruptJob.deserialize(resumed.serialize)
      completed.perform_now
    end

    test 'calls #to_h' do
      trigger_event

      %i[name time end transaction_id cpu_time idle_time allocations duration adapter job description
         completed_steps].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      trigger_event

      assert_equal({ name: 'resume.active_job' }, @event.slice(:name))
    end

    test 'returns an instance of Resume' do
      trigger_event

      assert_instance_of RailsBand::ActiveJob::Event::Resume, @event
    end

    test 'returns adapter' do
      trigger_event

      assert_instance_of ActiveJob::QueueAdapters::TestAdapter, @event.adapter
    end

    test 'returns job' do
      trigger_event

      assert_instance_of InterruptJob, @event.job
    end

    test 'returns description' do
      trigger_event

      assert_instance_of String, @event.description
    end

    test 'returns completed_steps' do
      trigger_event

      assert_equal %i[prepare finish], @event.completed_steps
    end

    test 'returns current_step as nil when every step is already completed' do
      trigger_event

      assert_nil @event.current_step
    end
  end
end
