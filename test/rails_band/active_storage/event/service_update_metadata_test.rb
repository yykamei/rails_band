# frozen_string_literal: true

require 'test_helper'

class ServiceUpdateMetadataTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveStorage::LogSubscriber.consumers = {
      'service_update_metadata.active_storage': ->(event) { @event = event }
    }
  end

  def event_name
    'service_update_metadata.active_storage'
  end

  def trigger_event
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }
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
