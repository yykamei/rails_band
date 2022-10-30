# frozen_string_literal: true

require 'test_helper'

class ActionMailerLogSubscriberTest < ActionDispatch::IntegrationTest
  setup do
    @mock = Minitest::Mock.new
    @mock.expect(:recv, nil)
    @user = User.create!(name: 'bo', email: 'bo@example.com')
  end

  test 'use the consumer with the exact event name' do
    RailsBand::ActionMailer::LogSubscriber.consumers = {
      'deliver.action_mailer': ->(_event) { @mock.recv }
    }
    get "/users/#{@user.id}/welcome_email"

    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    RailsBand::ActionMailer::LogSubscriber.consumers = {
      action_mailer: ->(event) { @mock.recv if event.name == 'deliver.action_mailer' }
    }
    get "/users/#{@user.id}/welcome_email"

    assert_mock @mock
  end

  test 'use the consumer with default' do
    RailsBand::ActionMailer::LogSubscriber.consumers = {
      default: ->(event) { @mock.recv if event.name == 'deliver.action_mailer' }
    }
    get "/users/#{@user.id}/welcome_email"

    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::ActionMailer::LogSubscriber.consumers = {
      'unknown.action_mailer': ->(_event) { @mock.recv }
    }
    get "/users/#{@user.id}/welcome_email"
    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
