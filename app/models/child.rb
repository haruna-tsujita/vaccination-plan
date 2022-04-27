# frozen_string_literal: true

class Child < ApplicationRecord
  has_many :histories, dependent: :destroy
  belongs_to :user
  has_one_attached :avatar

  validates :name, presence: true
  validates :birthday, presence: true
  validate :birthday_before_today

  def birthday_before_today
    return unless birthday

    errors.add(:birthday, 'は今日以前の日付にしてください') if birthday > Date.current
  end

  def self.calc_moon_age(birthday)
    moon_age = TimeDifference.between(birthday, Date.current).in_months
    "#{(moon_age / 12).floor}才 #{(moon_age % 12).floor}ヶ月"
  end
end
