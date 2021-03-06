# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true
  has_one_attached :avatar
end
