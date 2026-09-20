# frozen_string_literal: true

# A job that exercises Active Job Continuation. It interrupts itself on the
# first run inside the second checkpoint so that `interrupt.active_job` is emitted.
class InterruptJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :default

  class << self
    attr_accessor :runs, :finished
  end

  def perform
    step(:prepare) do
      self.class.runs = self.class.runs.to_i + 1
      interrupt!(reason: :testing) if self.class.runs == 1
    end
    step(:finish) do
      self.class.finished = true
    end
  end
end
