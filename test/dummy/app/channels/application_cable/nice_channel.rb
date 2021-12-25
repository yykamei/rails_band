# frozen_string_literal: true

module ApplicationCable
  class NiceChannel < ApplicationCable::Channel
    def hello(data)
      ActionCable.server.broadcast("nice_#{params[:number]}", data)
    end

    def call_transmit(data)
      transmit data, via: 'Hi!'
    end

    private

    def subscribed
      stream_from "nice_#{params[:number]}"
      reject if Integer(params[:number], exception: false).negative?
    end
  end
end
