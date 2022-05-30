# frozen_string_literal: true

class YayJob < ApplicationJob
  queue_as :default

  before_perform :check_abort
  before_enqueue :check_abort

  def perform(name:, message:, aborted: false)
    logger.info([name, message, aborted].to_json)
  end

  private

  def check_abort
    throw(:abort) if arguments.first[:aborted]
  end
end
