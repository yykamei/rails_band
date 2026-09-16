# frozen_string_literal: true

require 'test_helper'

class ServiceUrlTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveStorage::LogSubscriber.consumers = {
      'service_url.active_storage': ->(event) { @event = event }
    }
  end

  def event_name
    'service_url.active_storage'
  end

  def trigger_event
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }
  end

  test 'calls #to_h' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    %i[name time end transaction_id cpu_time idle_time allocations duration key service url].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_equal({ name: 'service_url.active_storage' }, @event.slice(:name))
  end

  test 'returns an instance of ServiceUpload' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of RailsBand::ActiveStorage::Event::ServiceUrl, @event
  end

  test 'returns the key' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_respond_to @event, :key
  end

  test 'returns the service' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_equal 'Disk', @event.service
  end

  test 'returns the url' do
    post '/teams', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert @event.url.starts_with?('http://www.example.com/rails/active_storage/disk')
  end
end
