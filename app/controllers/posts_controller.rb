class PostsController < ApplicationController
  def index
    friends_ids = Friendship.where(user_id: current_user.id, status: 2)
                            .pluck(:friend_id)
    @post = Post.new()
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
    if @post.save
      if request.headers['Referer'].include?('users')
        redirect_back_or_to :root
      else
        redirect_to :root
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    path = post_url(@post)
    @post.destroy
    if request.referer == path
      redirect_to :root
    else
      redirect_back_or_to :root
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
