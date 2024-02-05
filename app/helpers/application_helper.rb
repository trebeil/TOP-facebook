module ApplicationHelper
  def unseen_notifications
    current_user.notifications_viewed_at.nil? ||
      current_user.notifications_viewed_at < current_user.notifications.last.created_at
  end
end
