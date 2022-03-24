# frozen_string_literal: true

class Child < ApplicationRecord
  has_one_attached :avatar

  validates :name, presence: true
  validates :birthday, presence: true
  validate :birthday_before_today

  def birthday_before_today
    errors.add(:birthday, 'は今日以前の日付にしてください') if birthday > Date.current
  end
end
