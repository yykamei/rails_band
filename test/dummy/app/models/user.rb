class User < ApplicationRecord
  validates :email, presence: true
  validates :name, presence: true
end
