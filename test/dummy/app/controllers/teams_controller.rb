# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_host

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

    # HACK: service_update_metadata.active_storage is supported in GCS service only, so this test imitates the behavior.
    payload = {
      key: 'my-key',
      service: 'Disk',
      content_type: 'Content-Type!',
      disposition: 'Disposition'
    }
    ActiveSupport::Notifications.instrument('service_update_metadata.active_storage', **payload) do
      logger.debug(payload)
    end

    redirect_to team_path(team)
  end

  def preview
    team = Team.create!(params.require(:team).permit(:name, :avatar))

    # For preview
    team.avatar.preview(resize_to_limit: [100, 100]).processed.url

    redirect_to team_path(team)
  end

  private

  def set_host
    if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
      ActiveStorage::Current.url_options = { host: 'www.example.com' }
    else
      ActiveStorage::Current.host = 'www.example.com'
    end
  end
end
