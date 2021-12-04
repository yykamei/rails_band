# frozen_string_literal: true

module ApplicationCable
  class NiceChannel < ApplicationCable::Channel
    def hello(data)
      ActionCable.server.broadcast("nice_#{params[:number]}", data)
    end

    private

    def subscribed
      stream_from "nice_#{params[:number]}"
    end
  end
end
