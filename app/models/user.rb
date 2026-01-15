class User < ApplicationRecord
  has_secure_password

  enum :role, { guest: 0, host: 1, admin: 2 }

  has_many :events, dependent: :destroy      # Events created as Host
  has_many :rsvps, dependent: :destroy       # RSVPs made as Guest

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :role, presence: true
end
