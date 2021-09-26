# frozen_string_literal: true

require 'test_helper'

class RailsBandTest < ActiveSupport::TestCase
  test 'it has a version number' do
    assert RailsBand::VERSION
  end

  test 'it adds a new configuration' do
    assert_instance_of RailsBand::Configuration, Rails.application.config.rails_band
  end
end
