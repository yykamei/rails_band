# frozen_string_literal: true

require 'test_helper'

if defined?(ActiveJob::Continuable)
  class StepStartedTest < ActiveSupport::TestCase
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveJob::LogSubscriber.consumers = {
        'step_started.active_job': ->(event) { @event = event }
      }
      InterruptJob.runs = 0
    end

    def event_name
      'step_started.active_job'
    end

    def trigger_event
      InterruptJob.perform_now
    end

    test 'calls #to_h' do
      trigger_event

      %i[name time end transaction_id cpu_time idle_time allocations duration adapter job step].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      trigger_event

      assert_equal({ name: 'step_started.active_job' }, @event.slice(:name))
    end

    test 'returns an instance of StepStarted' do
      trigger_event

      assert_instance_of RailsBand::ActiveJob::Event::StepStarted, @event
    end

    test 'returns adapter' do
      trigger_event

      assert_instance_of ActiveJob::QueueAdapters::TestAdapter, @event.adapter
    end

    test 'returns job' do
      trigger_event

      assert_instance_of InterruptJob, @event.job
    end

    test 'returns step' do
      trigger_event

      assert_instance_of ActiveJob::Continuation::Step, @event.step
      assert_equal :prepare, @event.step.name
    end
  end
end
