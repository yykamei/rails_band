# frozen_string_literal: true

require 'test_helper'

class PreviewTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveStorage::LogSubscriber.consumers = {
      'preview.active_storage': ->(event) { @event = event }
    }
  end

  def event_name
    'preview.active_storage'
  end

  def trigger_event
    post '/teams/preview', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }
  end

  test 'calls #to_h' do
    post '/teams/preview', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    %i[name time end transaction_id cpu_time idle_time allocations duration key].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    post '/teams/preview', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_equal({ name: 'preview.active_storage' }, @event.slice(:name))
  end

  test 'returns an instance of ServiceUpload' do
    post '/teams/preview', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of RailsBand::ActiveStorage::Event::Preview, @event
  end

  test 'returns the key' do
    post '/teams/preview', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_respond_to @event, :key
  end
end
