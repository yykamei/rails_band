# frozen_string_literal: true

require 'test_helper'

class ActionViewLogSubscriberTest < ActionDispatch::IntegrationTest
  setup do
    @mock = Minitest::Mock.new
    @mock.expect(:recv, nil)
  end

  test 'use the consumer with the exact event name' do
    RailsBand::ActionView::LogSubscriber.consumers = {
      'render_template.action_view': ->(_event) { @mock.recv }
    }
    get '/users'

    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    RailsBand::ActionView::LogSubscriber.consumers = {
      action_view: ->(event) { @mock.recv if event.name == 'render_template.action_view' }
    }
    get '/users'

    assert_mock @mock
  end

  test 'use the consumer with default' do
    RailsBand::ActionView::LogSubscriber.consumers = {
      default: ->(event) { @mock.recv if event.name == 'render_template.action_view' }
    }
    get '/users'

    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::ActionView::LogSubscriber.consumers = {
      'unknown.action_view': ->(_event) { @mock.recv }
    }
    get '/users'
    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
