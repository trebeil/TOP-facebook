class LikesController < ApplicationController
  def create
    like = Like.new(like_params)
    like.user_id = current_user.id
    like.save

    # Create notification unless like author is the post/comment author
    unless like.user_id == like.likeable.user_id
      path = if like.likeable_type == 'Post'
               post_path(like.likeable.id)
             else
               post_path(like.likeable.post.id)
             end
      Notification.create(notificationable_id: like.id,
                          notificationable_type: 'Like',
                          user_id: like.likeable.author.id,
                          text: notification_text(like),
                          path: path)
    end
    redirect_back_or_to :root
  end

  def destroy
    Like.destroy(params[:id])
    redirect_back_or_to :root
  end

  private

  def notification_text(like)
    if like.likeable_type == 'Post'
      "#{like.user.name} #{like.user.last_name} has liked your post"
    elsif like.likeable_type == 'Comment'
      "#{like.user.name} #{like.user.last_name} has liked your comment"
    end
  end

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end
end
