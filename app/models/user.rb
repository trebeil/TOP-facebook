class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :timeoutable

  before_destroy do |user|
    Friendship.where(friend_id: user.id).each do |f|
      f.destroy
    end
  end

  has_many :posts, inverse_of: 'author', dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :notifications
  validates :email, presence: true
end
