# frozen_string_literal: true

class RateLimitedController < ApplicationController
  if Gem::Version.new(Rails.version) >= Gem::Version.new('8.0')
    self.cache_store = ActiveSupport::Cache::MemoryStore.new
    rate_limit to: 2, within: 2.seconds, name: 'test-limit'
  end

  def limited
    head :ok
  end
end
