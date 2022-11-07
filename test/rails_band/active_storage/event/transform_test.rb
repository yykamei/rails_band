# frozen_string_literal: true

require 'test_helper'

class TransformTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveStorage::LogSubscriber.consumers = {
      'transform.active_storage': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_equal 'transform.active_storage', @event.name
  end

  test 'returns time' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    post '/teams/transform', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

    assert_instance_of Float, @event.duration
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
