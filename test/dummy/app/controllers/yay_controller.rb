# frozen_string_literal: true

class YayController < ApplicationController
  def index
    YayJob.set(wait: 30.seconds).perform_later(name: 'foo', message: 'Hi')
    head :no_content
  end

  def show
    YayJob.perform_later(name: 'E!', message: 'This is E.')
    head :no_content
  end
end
