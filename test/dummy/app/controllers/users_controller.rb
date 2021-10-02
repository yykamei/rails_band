class UsersController < ApplicationController
  def index
    @users = User.all
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
end
