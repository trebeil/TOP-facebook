class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @name = if @user == current_user
              'My'
            else
              if @user.name.downcase[-1] != 's'
                "#{@user.name}'s"
              else
                "#{@user.name}'"
              end
            end
    friends_ids = Friendship.where(user_id: @user.id, status: 2).pluck(:friend_id)
    friends_ids.delete(current_user.id)
    if current_user == @user
      @friends = User.where(id: friends_ids).order(:name)
    else
      current_user_friends_ids = Friendship.where(user_id: current_user.id, status: 2).pluck(:friend_id)
      common_friends_ids = friends_ids.intersection(current_user_friends_ids)
      other_friends_ids = friends_ids.difference(common_friends_ids)
      @friends_in_common = User.where(id: common_friends_ids).order(:name)
      @other_friends = User.where(id: other_friends_ids).order(:name)
    end
    @post = Post.new()
    @posts = Post.where(user_id: @user.id).order(created_at: :desc).limit(10)
  end

  def index
    @users = User.all.excluding(current_user).order(:name)
  end
end
