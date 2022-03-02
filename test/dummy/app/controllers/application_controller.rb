# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def default_url_options
    { host: 'www.example.com' }
  end
end
