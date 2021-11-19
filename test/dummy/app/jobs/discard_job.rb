# frozen_string_literal: true

class DiscardJob < ApplicationJob
  class Error < StandardError; end

  queue_as :default

  discard_on Error

  def perform
    raise Error, '🚮'
  end
end
