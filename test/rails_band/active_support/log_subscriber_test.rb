# frozen_string_literal: true

require 'test_helper'

class ActiveSupportLogSubscriberTest < ActionDispatch::IntegrationTest
  setup do
    @mock = Minitest::Mock.new
    @mock.expect(:recv, nil)
    @user = User.create!(name: 'mc', email: 'mc@example.com')
  end

  test 'use the consumer with the exact event name' do
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      'cache_read.active_support': ->(_event) { @mock.recv }
    }
    get "/users/#{@user.id}/cache"

    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      active_support: ->(event) { @mock.recv if event.name == 'cache_read.active_support' }
    }
    get "/users/#{@user.id}/cache"

    assert_mock @mock
  end

  test 'use the consumer with default' do
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      default: ->(event) { @mock.recv if event.name == 'cache_read.active_support' }
    }
    get "/users/#{@user.id}/cache"

    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      'unknown.active_support': ->(_event) { @mock.recv }
    }
    get "/users/#{@user.id}/cache"
    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
