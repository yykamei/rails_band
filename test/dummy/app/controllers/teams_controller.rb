# frozen_string_literal: true

class TeamsController < ApplicationController
  def create
    team = Team.create!(params.require(:team).permit(:name, :avatar))
    redirect_to team_path(team)
  end
end
