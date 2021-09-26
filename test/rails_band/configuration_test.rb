# frozen_string_literal: true

require 'test_helper'

module RailsBand
  class ConfigurationTest < ActiveSupport::TestCase
    test 'it can accept the consumer with a block' do
      config = RailsBand::Configuration.new
      config.consumer = ->(v) { v + 1 }
      assert_includes config.consumer, :all
      assert_equal 4, config.consumer.fetch(:all).call(3)
    end

    test 'it can accept the consumer with a specific events' do
      config = RailsBand::Configuration.new
      config.consumer[:action_controller] = ->(v) { v * 2 }
      assert_includes config.consumer, :action_controller
      assert_equal 6, config.consumer.fetch(:action_controller).call(3)
    end
  end
end
