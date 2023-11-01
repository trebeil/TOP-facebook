class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all.excluding(current_user).order(:name)
  end
end
