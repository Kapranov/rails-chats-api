class User < ApplicationRecord
  has_many :chats_users
  has_many :chats, through: :chats

  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
