# frozen_string_literal: true

require 'test_helper'

class ActionMailboxLogSubscriberTest < ActionDispatch::IntegrationTest
  setup do
    @mock = Minitest::Mock.new
    @mock.expect(:recv, nil)
    @user = User.create!(name: 'bo', email: 'bo@example.com')
  end

  test 'use the consumer with the exact event name' do
    RailsBand::ActionMailbox::LogSubscriber.consumers = {
      'process.action_mailbox': ->(_event) { @mock.recv }
    }
    get "/users/#{@user.id}/mailbox"

    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    RailsBand::ActionMailbox::LogSubscriber.consumers = {
      action_mailbox: ->(event) { @mock.recv if event.name == 'process.action_mailbox' }
    }
    get "/users/#{@user.id}/mailbox"

    assert_mock @mock
  end

  test 'use the consumer with default' do
    RailsBand::ActionMailbox::LogSubscriber.consumers = {
      default: ->(event) { @mock.recv if event.name == 'process.action_mailbox' }
    }
    get "/users/#{@user.id}/mailbox"

    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::ActionMailbox::LogSubscriber.consumers = {
      'unknown.action_mailbox': ->(_event) { @mock.recv }
    }
    get "/users/#{@user.id}/mailbox"
    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
