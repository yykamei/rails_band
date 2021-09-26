# frozen_string_literal: true

Rails.application.config.rails_band.consumer = ->(event) { Rails.logger.info(event) }
