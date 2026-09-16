# frozen_string_literal: true

require 'test_helper'

class TransformTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveStorage::LogSubscriber.consumers = {
      'transform.active_storage': ->(event) { @event = event }
    }
  end

  def event_name
    'transform.active_storage'
  end

  def trigger_event
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }
  end

  test 'calls #to_h' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    %i[name time end transaction_id cpu_time idle_time allocations duration].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_equal({ name: 'transform.active_storage' }, @event.slice(:name))
  end

  test 'returns an instance of ServiceUpload' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of RailsBand::ActiveStorage::Event::Transform, @event
  end
end
