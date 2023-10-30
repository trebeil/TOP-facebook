class LikesController < ApplicationController
  def create
    like = Like.create(like_params)

    # Create notification unless like author is the post author
    unless like.user_id == like.likeable.user_id
      Notification.create(notificationable_id: like.id,
                          notificationable_type: 'Like',
                          user_id: like.likeable.author.id,
                          text: "#{like.user.name} #{like.user.last_name} liked your post")
    end
    redirect_back_or_to :root
  end

  def destroy
    Like.destroy(params[:id])
    redirect_back_or_to :root
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :likeable_id, :likeable_type)
  end
end
