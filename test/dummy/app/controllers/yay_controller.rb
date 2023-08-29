# frozen_string_literal: true

class YayController < ApplicationController
  def index
    aborted = ActiveModel::Type::Boolean.new.cast(params[:aborted])
    YayJob.set(wait: 30.seconds).perform_later(name: 'foo', message: 'Hi', **{ aborted: aborted }.compact)
    head :no_content
  end

  def show
    aborted = ActiveModel::Type::Boolean.new.cast(params[:aborted])
    YayJob.perform_later(name: 'E!', message: 'This is E.', **{ aborted: aborted }.compact)

    if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1.0.alpha')
      ActiveJob.perform_all_later(YayJob.new(name: 'F!', message: 'This is F.'))
    end
    head :no_content
  end
end
