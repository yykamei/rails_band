# frozen_string_literal: true

require 'test_helper'

if defined?(ActiveJob::Continuable)
  class InterruptTest < ActiveSupport::TestCase
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveJob::LogSubscriber.consumers = {
        'interrupt.active_job': ->(event) { @event = event }
      }
      InterruptJob.runs = 0
      InterruptJob.finished = false
    end

    def event_name
      'interrupt.active_job'
    end

    def trigger_event
      InterruptJob.perform_now
    end

    test 'calls #to_h' do
      trigger_event

      %i[name time end transaction_id cpu_time idle_time allocations duration adapter job reason description
         completed_steps].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      trigger_event

      assert_equal({ name: 'interrupt.active_job' }, @event.slice(:name))
    end

    test 'returns an instance of Interrupt' do
      trigger_event

      assert_instance_of RailsBand::ActiveJob::Event::Interrupt, @event
    end

    test 'returns adapter' do
      trigger_event

      assert_instance_of ActiveJob::QueueAdapters::TestAdapter, @event.adapter
    end

    test 'returns job' do
      trigger_event

      assert_instance_of InterruptJob, @event.job
    end

    test 'returns reason' do
      trigger_event

      assert_equal :testing, @event.reason
    end

    test 'returns description' do
      trigger_event

      assert_instance_of String, @event.description
    end

    test 'returns completed_steps' do
      trigger_event

      assert_instance_of Array, @event.completed_steps
    end

    test 'returns current_step' do
      trigger_event

      assert_instance_of ActiveJob::Continuation::Step, @event.current_step
    end

    test 'does not complete the job when interrupted' do
      trigger_event

      refute InterruptJob.finished
    end
  end
end
