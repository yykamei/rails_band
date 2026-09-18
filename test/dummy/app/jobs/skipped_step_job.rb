# frozen_string_literal: true

# A job that exercises the skipping of an already completed step, so that
# `step_skipped.active_job` is emitted. The first run completes both steps;
# the second run replays them, and the already completed ones emit the event.
class SkippedStepJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :default

  def perform
    step(:first) { nil }
    step(:second) { nil }
  end
end
