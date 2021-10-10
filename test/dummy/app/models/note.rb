# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
end
