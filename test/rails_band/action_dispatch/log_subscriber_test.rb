# frozen_string_literal: true

require 'test_helper'

class ActionDispatchLogSubscriberTest < ActionDispatch::IntegrationTest
  setup do
    @mock = Minitest::Mock.new
    @mock.expect(:recv, nil)
  end

  test 'use the consumer with the exact event name' do
    RailsBand::ActionDispatch::LogSubscriber.consumers = {
      'process_middleware.action_dispatch': ->(_event) { @mock.recv }
    }
    get '/users'
    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    RailsBand::ActionDispatch::LogSubscriber.consumers = {
      action_dispatch: ->(event) { @mock.recv if event.name == 'process_middleware.action_dispatch' }
    }
    get '/users'
    assert_mock @mock
  end

  test 'use the consumer with default' do
    RailsBand::ActionDispatch::LogSubscriber.consumers = {
      default: ->(event) { @mock.recv if event.name == 'process_middleware.action_dispatch' }
    }
    get '/users'
    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::ActionDispatch::LogSubscriber.consumers = {
      'unknown.action_dispatch': ->(_event) { @mock.recv }
    }
    get '/users'
    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
