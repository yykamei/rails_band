# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :halt!, only: :callback

  def index
    @users = User.all
    fragment_exist?(@users)
    expire_fragment(@users)
  end

  def create
    @user = User.new(params.require(:user).permit(:email, :name))
    @user.save!
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params.require(:id))
  end

  def show
    @user = User.find(params.require(:id))
  end

  def update
    @user = User.find(params.require(:id))
    @user.update!(params.permit(:email, :name))
  end

  def destroy
    User.find(params.require(:id)).destroy!
  end

  def flawed
    raise 'Sorry'
  end

  def file
    send_file Rails.root.join('public/404.html'), filename: 'power.html'
  end

  def data
    send_data 'Hello!', status: 201, filename: 'power.html'
  end

  def redirect
    redirect_to users_path
  end

  def callback
    render json: { reached: true }
  end

  def notes
    @user = User.find(params.require(:user_id))
    @user.strict_loading!
    @user.notes.to_a
    redirect_to users_path
  end

  def welcome_email
    user = User.find(params.require(:user_id))
    WelcomeMailer.with(user: user).hi.deliver_now
    redirect_to users_path
  end

  def cache
    user = User.find(params.require(:user_id))
    result = Rails.cache.fetch("key_#{user.id}", expires_in: 1.minutes) do
      user.slow_method
    end
    logger.info(result)
    redirect_to user_path(user)
  end

  def cache2
    Rails.cache.fetch('ok', expires_in: 1.minutes) { 'ok' }
    result = Rails.cache.fetch('ok', expires_in: 1.minutes) { 'ok' }
    Rails.cache.delete('DEL!')
    Rails.cache.exist?('nonexistent')
    Rails.cache.fetch_multi(*%w[a b c]) { [] }
    logger.info(result)
    redirect_to users_path
  end

  def cache3
    Rails.cache.write_multi(w1: 1, w2: 2)
    Rails.cache.delete_multi(['ok', :df]) if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
    redirect_to users_path
  end

  def cache4
    # HACK: This code simulates the events that are specific to any cache store.
    ActiveSupport::Notifications.instrument('cache_increment.active_support',
                                            { key: 'INC1', store: 'RedisCacheStore', amount: 1 }) do
      # noop
    end
    ActiveSupport::Notifications.instrument('cache_decrement.active_support',
                                            { key: 'DEC1', store: 'RedisCacheStore', amount: 1 }) do
      # noop
    end
    ActiveSupport::Notifications.instrument('cache_delete_matched.active_support',
                                            { key: 'MyDeleteMatched', store: 'Store!' }) do
      # noop
    end
    ActiveSupport::Notifications.instrument('cache_cleanup.active_support',
                                            { store: 'Store!', size: 2 }) do
      # noop
    end
    redirect_to users_path
  end

  def deprecation
    ActiveSupport::Deprecation.new('2.0').tap do |deprecator|
      deprecator.behavior = :notify
      deprecator.warn('deprecated!!!')
    end
    redirect_to users_path
  end

  private

  def halt!
    redirect_to users_path
  end
end
