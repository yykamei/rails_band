# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
  class AnalyzeTest < ActionDispatch::IntegrationTest
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveStorage::LogSubscriber.consumers = {
        'analyze.active_storage': ->(event) { @event = event }
      }
    end

    def event_name
      'analyze.active_storage'
    end

    def trigger_event
      post '/teams/analyze', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }
    end

    test 'calls #to_h' do
      post '/teams/analyze', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

      %i[name time end transaction_id cpu_time idle_time allocations duration analyzer].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      post '/teams/analyze', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

      assert_equal({ name: 'analyze.active_storage' }, @event.slice(:name))
    end

    test 'returns an instance of ServiceUpload' do
      post '/teams/analyze', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

      assert_instance_of RailsBand::ActiveStorage::Event::Analyze, @event
    end

    test 'returns the analyzer' do
      post '/teams/analyze', params: { team: { name: 'A', avatar: fixture_file_upload('test.png') } }

      assert_equal 'mini_magick', @event.analyzer
    end
  end
end
