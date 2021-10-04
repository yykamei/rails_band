# frozen_string_literal: true

class UsersController < ApplicationController
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
    @user.update!(params.require(:user).permit(:email, :name))
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
end
