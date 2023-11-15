class Posts::CommentsController < ApplicationController
  before_action :check_authorization, except: [:destroy]
  before_action :check_authorization_for_destroy, only: :destroy

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments
  end

  def new
    @comment = Comment.new(post_id: params[:post_id])
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        unless current_user == @comment.post.author
          Notification.create(notificationable_id: @comment.id,
                              notificationable_type: 'Comment',
                              user_id: @comment.post.author.id,
                              text: "#{current_user.name} #{current_user.last_name} has commented on your post",
                              path: post_path(@comment.post.id))
        end
        format.turbo_stream
        format.html { redirect_to post_comments_path(@comment.post) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back_or_to :root }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

  def check_authorization
    post = Post.find(params[:post_id])
    unless post.author == current_user || post.author.friends.exists?(id: current_user.id)
      redirect_back_or_to :root, status: 403
    end
  end

  def check_authorization_for_destroy
    comment = Comment.find(params[:id])
    unless comment.author == current_user || comment.post.author == current_user
      redirect_back_or_to :root, status: 403
    end
  end
end
