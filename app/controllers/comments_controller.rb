class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_back_or_to :root
    else
      flash[:error] = 'Invalid comment'
      redirect_back_or_to :root
    end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :user_id)
  end
end
