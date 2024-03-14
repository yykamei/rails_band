# frozen_string_literal: true

class SpecialStreamController < ApplicationController
  include ActionController::Live

  def index
    send_stream filename: 'special.txt' do |stream|
      10.times do
        stream.write "a\n"
      end
    end
  end
end
