# frozen_string_literal: true

require 'test_helper'

module RailsBand
  class RailtieTest < ::ActiveSupport::TestCase
    test 'rails_8_1_or_newer? returns true for Rails 8.1+' do
      # Current Rails version should be 8.1+ based on Gemfile
      assert_predicate RailsBand::Railtie, :rails_8_1_or_newer?
    end

    test 'unsubscribe_default_log_subscriber removes Rails 8.1+ log subscribers' do
      # Ensure ActionDispatch::LogSubscriber is loaded and subscribed
      require 'action_dispatch'

      # Get initial subscriber count
      initial_count = ::ActiveSupport.event_reporter.subscribers.count do |s|
        s[:subscriber].is_a?(::ActionDispatch::LogSubscriber)
      end

      # If there's already a subscriber, test unsubscribing it
      if initial_count.positive?
        RailsBand::Railtie.unsubscribe_default_log_subscriber(::ActionDispatch::LogSubscriber)

        final_count = ::ActiveSupport.event_reporter.subscribers.count do |s|
          s[:subscriber].is_a?(::ActionDispatch::LogSubscriber)
        end

        assert_operator final_count, :<, initial_count,
                        "Expected subscriber count to decrease from #{initial_count} to less, got #{final_count}"
      else
        # If no subscribers, the test can't verify unsubscribe behavior
        # but we can verify the method doesn't crash
        assert_nothing_raised do
          RailsBand::Railtie.unsubscribe_default_log_subscriber(::ActionDispatch::LogSubscriber)
        end
      end
    end

    test 'unsubscribe_default_log_subscriber works with multiple subscriber types' do
      require 'action_controller'
      require 'action_view'

      # Track subscribers before unsubscribing
      subscriber_types = [
        ::ActionController::LogSubscriber,
        ::ActionView::LogSubscriber
      ]

      subscriber_types.each do |subscriber_class|
        # Should not raise an error even if subscriber doesn't exist
        assert_nothing_raised do
          RailsBand::Railtie.unsubscribe_default_log_subscriber(subscriber_class)
        end
      end
    end
  end
end
