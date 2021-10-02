# frozen_string_literal: true

Rails.application.config.rails_band.consumers = ->(event) { Rails.logger.info(event) }
