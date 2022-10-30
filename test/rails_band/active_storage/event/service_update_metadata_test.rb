# frozen_string_literal: true

require 'test_helper'

class ServiceUpdateMetadataTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveStorage::LogSubscriber.consumers = {
      'service_update_metadata.active_storage': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_equal 'service_update_metadata.active_storage', @event.name
  end

  test 'returns time' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }
    %i[name time end transaction_id cpu_time idle_time allocations duration key service
       content_type disposition].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_equal({ name: 'service_update_metadata.active_storage' }, @event.slice(:name))
  end

  test 'returns an instance of ServiceUpload' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of RailsBand::ActiveStorage::Event::ServiceUpdateMetadata, @event
  end

  test 'returns the key' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_respond_to @event, :key
  end

  test 'returns the service' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_equal 'Disk', @event.service
  end

  test 'returns the content_type' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_equal 'Content-Type!', @event.content_type
  end

  test 'returns the disposition' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_equal 'Disposition', @event.disposition
  end
end
