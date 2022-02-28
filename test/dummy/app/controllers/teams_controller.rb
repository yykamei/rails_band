# frozen_string_literal: true

class TeamsController < ApplicationController
  def create
    team = Team.create!(params.require(:team).permit(:name, :avatar))
    team.avatar.download do |data|
      logger.debug(data.size)
    end
    team.avatar.download_chunk(0...40) do |data|
      logger.debug(data.size)
    end
    redirect_to team_path(team)
  end
end
