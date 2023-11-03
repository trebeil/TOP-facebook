class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :timeoutable, :omniauthable, omniauth_providers: [:google_oauth2]

  before_destroy do |user|
    Friendship.where(friend_id: user.id).each do |f|
      f.destroy
    end
  end

  after_create do |user|
    unless user.photo
      photo_url = "https://gravatar.com/avatar/#{Digest::SHA256.hexdigest(user.email)}"
      user.update(photo: photo_url)
    end
  end

  has_many :posts, inverse_of: 'author', dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :notifications, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, inverse_of: 'author', dependent: :destroy
  validates :email, presence: true

  def self.from_omniauth(access_token)
    data = access_token.info
    User.where(email: data['email']).first
  end

  def self.persist_user(access_token)
    data = access_token.info
    User.create(name: data['first_name'],
                last_name: data['last_name'],
                email: data['email'],
                password: Devise.friendly_token[0,20],
                photo: data['image'])
  end

  def create_friendship(friend)
    Friendship.create(user_id: self.id, friend_id: friend.id, status: 1)
  end

  def friendship(user)
    Friendship.find_by user_id: self.id, friend_id: user.id
  end

  def friendship_confirmed?(user)
    return false unless self.friendship(user)

    true if self.friendship(user).status == 2
  end
end
