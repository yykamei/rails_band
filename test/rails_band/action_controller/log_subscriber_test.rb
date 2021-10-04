# frozen_string_literal: true

require 'test_helper'

class LogSubscriberTest < ActionDispatch::IntegrationTest
  setup do
    @mock = Minitest::Mock.new
    @mock.expect(:recv, nil)
  end

  test 'use the consumer with the exact event name' do
    RailsBand::ActionController::LogSubscriber.consumers = {
      'process_action.action_controller': ->(_event) { @mock.recv }
    }
    get '/users'
    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    RailsBand::ActionController::LogSubscriber.consumers = {
      action_controller: ->(_event) { @mock.recv }
    }
    get '/users'
    assert_mock @mock
  end

  test 'use the consumer with default' do
    RailsBand::ActionController::LogSubscriber.consumers = {
      default: ->(_event) { @mock.recv }
    }
    get '/users'
    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::ActionController::LogSubscriber.consumers = {
      'unknown.action_controller': ->(_event) { @mock.recv }
    }
    get '/users'
    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
