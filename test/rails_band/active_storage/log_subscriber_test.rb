# frozen_string_literal: true

require 'test_helper'

class ActiveStorageSubscriberTest < ::ActionDispatch::IntegrationTest
  setup do
    @mock = Minitest::Mock.new
    @mock.expect(:recv, nil)
  end

  test 'use the consumer with the exact event name' do
    RailsBand::ActiveStorage::LogSubscriber.consumers = {
      'service_upload.active_storage': ->(_event) { @mock.recv }
    }
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_mock @mock
  end

  test 'use the consumer with namespace' do
    RailsBand::ActiveStorage::LogSubscriber.consumers = {
      active_storage: ->(event) { @mock.recv if event.name == 'service_upload.active_storage' }
    }
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_mock @mock
  end

  test 'use the consumer with default' do
    RailsBand::ActiveStorage::LogSubscriber.consumers = {
      default: ->(event) { @mock.recv if event.name == 'service_upload.active_storage' }
    }
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_mock @mock
  end

  test 'do not use the consumer because the event is not for the target' do
    RailsBand::ActiveStorage::LogSubscriber.consumers = {
      'unknown.active_storage': ->(_event) { @mock.recv }
    }
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_raises MockExpectationError do
      @mock.verify
    end
  end
end
