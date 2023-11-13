class NotificationsController < ApplicationController
  before_action :check_authorization, only: :destroy

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_back_or_to :root
  end

  private

  def check_authorization
    notification = Notification.find(params[:id])
    unless notification.user_id == current_user.id
      redirect_back_or_to :root, status: 403
    end
  end
end
