# frozen_string_literal: true

require 'test_helper'

class ActionCableSubscriberTest < ::ActionCable::Channel::TestCase
  tests ApplicationCable::NiceChannel

  setup do
    @mock = Minitest::Mock.new
    @mock.expect(:recv, nil)
  end

  test 'use the consumer with the exact event name' do
    RailsBand::ActionCable::LogSubscriber.consumers = {
      'perform_action.action_cable': ->(_event) { @mock.recv }
    }
    subscribe number: '2'
    perform :hello, { name: 'J' }

    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    RailsBand::ActionCable::LogSubscriber.consumers = {
      action_cable: ->(event) { @mock.recv if event.name == 'perform_action.action_cable' }
    }
    subscribe number: '2'
    perform :hello, { name: 'J' }

    assert_mock @mock
  end

  test 'use the consumer with default' do
    RailsBand::ActionCable::LogSubscriber.consumers = {
      default: ->(event) { @mock.recv if event.name == 'perform_action.action_cable' }
    }
    subscribe number: '2'
    perform :hello, { name: 'J' }

    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::ActionCable::LogSubscriber.consumers = {
      'unknown.action_cable': ->(_event) { @mock.recv }
    }

    subscribe number: '2'
    perform :hello, { name: 'J' }

    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
