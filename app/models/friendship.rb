class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  has_many :notifications, as: :notificationable, dependent: :destroy

  # Friendships statuses are:
  #   1: Friendship request sent, pending approval
  #   2: Friendship request approved
  # If friendship is declined by receiver or canceled by requester, delete Friendship entry

  def create_mirror_friendship
    requester_id = self.user_id
    requested_id = self.friend_id
    Friendship.create(user_id: requested_id, friend_id: requester_id, status: 1)
  end

  # If friendship status == 1, create a notification to requested telling that
  # the requester sent a friend request. Else, create a notification to requester
  # telling that the requested accepted the request.
  def create_notification
    if self.status == 1
      Notification.create(user_id: self.requested.id,
                          notificationable_id: self.id,
                          notificationable_type: 'Friendship',
                          text: "#{self.requester.name} #{self.requester.last_name} has sent you a friend request")
    else
      Notification.create(user_id: self.requester.id,
                          notificationable_id: self.id,
                          notificationable_type: 'Friendship',
                          text: "#{self.requested.name} #{self.requested.last_name} has accepted your friend request")
    end
  end

  def mirror_friendship
    requester_id = self.user_id
    requested_id = self.friend_id
    Friendship.find_by(user_id: requested_id, friend_id: requester_id)
  end

  def requester
    self.original_friendship_request.user
  end

  def requested
    self.original_friendship_request.friend
  end

  def other_party(user)
    if user == self.requester
      self.requested
    else
      self.requester
    end
  end

  private

  def original_friendship_request
    if self.id < self.mirror_friendship.id
      self
    else
      self.mirror_friendship
    end
  end
end
