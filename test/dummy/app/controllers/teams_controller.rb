# frozen_string_literal: true

class TeamsController < ApplicationController
  def create
    team = Team.create!(params.require(:team).permit(:name, :avatar))
    team.avatar.download do |data|
      # For service_streaming_download
      logger.debug(data.size)
    end

    # For service_download
    team.avatar.download

    # For service_url
    team.avatar.service_url_for_direct_upload

    service = ActiveStorage::Blob.service
    service.download_chunk(team.avatar.blob.key, 0...40) do |data|
      # For service_download_chunk
      logger.debug(data.size)
    end

    # For service_delete
    service.delete(team.avatar.blob.key)

    # For service_delete_prefixed
    service.delete_prefixed('my-prefix')

    # For service_exist
    service.exist?(team.avatar.blob.key)

    redirect_to team_path(team)
  end
end
