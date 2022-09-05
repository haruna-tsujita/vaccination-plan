# frozen_string_literal: true

class Child < ApplicationRecord
  AVATAR_SIZE = '80x80>'
  has_many :histories, dependent: :destroy
  belongs_to :user
  has_one_attached :avatar
  has_one :option, dependent: :destroy
  accepts_nested_attributes_for :option, update_only: true

  validates :name, presence: true
  validates :birthday, presence: true
  validate :birthday_before_today

  def birthday_before_today
    return unless birthday

    errors.add(:birthday, 'は今日以前の日付にしてください') if birthday > Date.current
  end

  def avatar_url
    if avatar.attached?
      begin
        avatar.variant(resize: AVATAR_SIZE).processed.url
      rescue StandardError
        'default.png'
      end
    else
      'default.png'
    end
  end

  def calc_moon_age(today)
    moon_age = TimeDifference.between(birthday, today).in_months
    "#{(moon_age / 12).floor}才 #{(moon_age % 12).floor}ヶ月"
  end
end
