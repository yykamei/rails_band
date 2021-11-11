# frozen_string_literal: true

require 'test_helper'

class ActiveJobLogSubscriberTest < ActionDispatch::IntegrationTest
  setup do
    @mock = Minitest::Mock.new
    @mock.expect(:recv, nil)
  end

  test 'use the consumer with the exact event name' do
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      'enqueue_at.active_job': ->(_event) { @mock.recv }
    }
    get '/yay'
    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      active_job: ->(event) { @mock.recv if event.name == 'enqueue_at.active_job' }
    }
    get '/yay'
    assert_mock @mock
  end

  test 'use the consumer with default' do
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      default: ->(event) { @mock.recv if event.name == 'enqueue_at.active_job' }
    }
    get '/yay'
    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      'unknown.active_job': ->(_event) { @mock.recv }
    }
    get '/yay'
    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
