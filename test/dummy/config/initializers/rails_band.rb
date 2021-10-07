# frozen_string_literal: true

# Rails.application.config.rails_band.consumers = ->(event) { Rails.logger.info(event) }
Rails.application.config.rails_band.consumers = {
  default: ->(event) { Rails.logger.info(event.to_h) },
  action_controller: lambda { |event|
                       Rails.logger.info(event.slice(:name, :method, :path, :status, :controller, :action))
                     },
  'sql.active_record': ->(event) { Rails.logger.debug("#{event.sql_name}: #{event.sql}") }
}
