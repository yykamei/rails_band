# frozen_string_literal: true

module RailsBand
  # RailsBand::Railtie is responsible for preparing its configuration and accepting user-specified configs.
  class Railtie < ::Rails::Railtie
    config.rails_band = Configuration.new
  end
end
