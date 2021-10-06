# frozen_string_literal: true

require 'test_helper'

class ActiveRecordLogSubscriberTest < ActionDispatch::IntegrationTest
  setup do
    @mock = Minitest::Mock.new
  end

  test 'use the consumer with the exact event name' do
    @mock.expect(:recv, nil)
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      'sql.active_record': ->(_event) { @mock.recv }
    }
    get '/users'
    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    @mock.expect(:recv, nil)
    @mock.expect(:recv, nil)
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      active_record: ->(_event) { @mock.recv }
    }
    get '/users'
    assert_mock @mock
  end

  test 'use the consumer with default' do
    @mock.expect(:recv, nil)
    @mock.expect(:recv, nil)
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      default: ->(_event) { @mock.recv }
    }
    get '/users'
    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    @mock.expect(:recv, nil)
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      'unknown.active_record': ->(_event) { @mock.recv }
    }
    get '/users'
    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
