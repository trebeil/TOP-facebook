class LikesController < ApplicationController
  def create
    Like.create(like_params)
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
