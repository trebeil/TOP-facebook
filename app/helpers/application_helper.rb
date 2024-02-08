module ApplicationHelper
  def unseen_notifications
    if current_user.notifications.size == 0
      false
    else
      current_user.notifications_viewed_at.nil? ||
        current_user.notifications_viewed_at < current_user.notifications.last.created_at
    end
  end
end
