class PostsController < ApplicationController
  before_action :check_authorization_for_destroy, only: :destroy
  before_action :check_authorization_for_show, only: :show

  def index
    friends_ids = Friendship.where(user_id: current_user.id, status: 2)
                            .pluck(:friend_id)
    @posts = Post.where(user_id: current_user.id)
                 .or(Post.where(user_id: friends_ids))
                 .order(created_at: :desc).limit(10)
  end

  def new
    @post = Post.new()
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    respond_to do |format|
      if @post.save
        format.turbo_stream
        format.html { redirect_back_or_to :root }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    path = post_url(@post)
    @post.destroy
    respond_to do |format|
      format.turbo_stream
      if request.referer == path
        format.html { redirect_to :root }
      else
        format.html { redirect_back_or_to :root }
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def check_authorization_for_destroy
    post = Post.find(params[:id])
    unless post.author == current_user
      redirect_back_or_to :root, status: 403
    end
  end

  def check_authorization_for_show
    post = Post.find(params[:id])
    unless post.author == current_user || post.author.friends.exists?(id: current_user.id)
      redirect_back_or_to :root, status: 403
    end
  end
end
