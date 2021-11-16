# frozen_string_literal: true

class FlakyJob < ApplicationJob
  class Error < StandardError; end

  queue_as :default

  retry_on Error, wait: 0.01.seconds, attempts: 3

  def perform
    raise Error, 'Something wrong happened!'
  end
end
