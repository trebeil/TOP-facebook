class CommentsController < ApplicationController
  before_action :check_authorization, only: :destroy

  def create
    comment = Comment.new(comment_params)
    comment.user_id = current_user.id
    if comment.save
      unless current_user == comment.post.author
        Notification.create(notificationable_id: comment.id,
                            notificationable_type: 'Comment',
                            user_id: comment.post.author.id,
                            text: "#{current_user.name} #{current_user.last_name} has commented on your post",
                            path: post_path(comment.post.id))
      end
      redirect_back_or_to :root
    else
      flash[:error] = 'Invalid comment'
      redirect_back_or_to :root
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_back_or_to :root
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

  def check_authorization
    comment = Comment.find(params[:id])
    unless comment.author == current_user || comment.post.author == current_user
      redirect_back_or_to :root, status: 403
    end
  end
end
