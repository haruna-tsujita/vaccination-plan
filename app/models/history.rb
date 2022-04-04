# frozen_string_literal: true

class History < ApplicationRecord
  belongs_to :child
  belongs_to :vaccination

  validates :vaccination_id, presence: true
  validate :history_before_today
  validate :bigger_than_before_history
  validate :smaller_than_after_history

  def history_before_today
    return if date.nil?

    errors.add(:date, 'は今日より前の日付にしてください') if date > Date.current
  end

  def bigger_than_before_history
    return if date.nil?

    vaccination = Vaccination.find(vaccination_id)
    last_letter = vaccination.key[-1]
    return if last_letter == '1'

    vaccination.key[-1] = (last_letter.to_i - 1).to_s
    before_id = Vaccination.find_by(key: vaccination.key).id
    before_history = History.find_by(vaccination_id: before_id, child_id: child_id)
    return if before_history.date.nil?

    errors.add(:date, 'が前回の期より前の日付になっています') if before_history.date > date
  end

  def smaller_than_after_history
    return if date.nil?

    vaccination = Vaccination.find(vaccination_id)
    last_letter = vaccination.key[-1]
    vaccination.key[-1] = (last_letter.to_i + 1).to_s

    next_period = Vaccination.find_by(key: vaccination.key)
    return if next_period.nil?

    next_history = History.find_by(vaccination_id: next_period.id, child_id: child_id)
    return if next_history.date.nil?

    errors.add(:date, 'が次回の期より後の日付になっています') if date > next_history.date
  end

  def self.automatically_vaccinated(vaccination_id, child_id)
    vaccination = Vaccination.find(vaccination_id)
    return if vaccination.key[-1] == '1'

    vaccinations = Vaccination.where(name: vaccination.name)
    the_vaccination_histories = vaccinations.collect do |vaccine|
      History.find_by(vaccination_id: vaccine.id, child_id: child_id) if vaccine.id < vaccination_id
    end
    the_vaccination_histories.compact.each do |history|
      history.update(vaccinated: true) unless History.find(history.id).date
    end
  end
end
