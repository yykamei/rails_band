# frozen_string_literal: true

class YayJob < ApplicationJob
  queue_as :default

  def perform(name:, message:)
    p [name, message]
  end
end
