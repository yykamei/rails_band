# frozen_string_literal: true

require 'test_helper'

class ActiveRecordLogSubscriberTest < ActionDispatch::IntegrationTest
  setup do
    @mock = Minitest::Mock.new
    @mock.expect(:recv, nil)
  end

  test 'use the consumer with the exact event name' do
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      'sql.active_record': ->(_event) { @mock.recv }
    }
    get '/users'

    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      active_record: ->(event) { @mock.recv if event.name == 'sql.active_record' }
    }
    get '/users'

    assert_mock @mock
  end

  test 'use the consumer with default' do
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      default: ->(event) { @mock.recv if event.name == 'sql.active_record' }
    }
    get '/users'

    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      'unknown.active_record': ->(_event) { @mock.recv }
    }
    get '/users'
    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
