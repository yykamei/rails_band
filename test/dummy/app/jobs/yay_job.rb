# frozen_string_literal: true

class YayJob < ApplicationJob
  queue_as :default

  def perform(name:, message:)
    logger.info([name, message].to_json)
  end
end
