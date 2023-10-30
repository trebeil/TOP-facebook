class NotificationsController < ApplicationController
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_back_or_to :root
  end
end
