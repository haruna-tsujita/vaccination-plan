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

  def self.calc_moon_age(today, birthday)
    moon_age = (today.year - birthday.year) * 12 + today.month - birthday.month - (today.day >= birthday.day ? 0 : 1)
    "#{moon_age / 12}才 #{moon_age % 12}ヶ月"
  end
end
