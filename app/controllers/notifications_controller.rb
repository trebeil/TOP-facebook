class NotificationsController < ApplicationController
  before_action :check_authorization, only: :destroy

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back_or_to :root }
    end
  end

  private

  def check_authorization
    notification = Notification.find(params[:id])
    unless notification.user_id == current_user.id
      redirect_back_or_to :root, status: 403
    end
  end
end
