# frozen_string_literal: true

require 'test_helper'

module RailsBand
  class ConfigurationTest < ActiveSupport::TestCase
    test 'it can accept the consumers with a block' do
      config = RailsBand::Configuration.new
      config.consumers = ->(v) { v + 1 }
      assert_includes config.consumers, :default
      assert_equal 4, config.consumers.fetch(:default).call(3)
    end

    test 'it can accept the consumers with a specific events' do
      config = RailsBand::Configuration.new
      config.consumers[:action_controller] = ->(v) { v * 2 }
      assert_includes config.consumers, :action_controller
      assert_equal 6, config.consumers.fetch(:action_controller).call(3)
    end
  end
end
