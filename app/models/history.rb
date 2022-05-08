# frozen_string_literal: true

class History < ApplicationRecord
  belongs_to :child
  belongs_to :vaccination

  validates :child_id, presence: true
  validates :vaccination_id, presence: true, uniqueness: { scope: :child }
  validate :history_before_today
  validate :bigger_than_before_history
  validate :smaller_than_after_history

  def history_before_today
    return if date.nil?

    errors.add(:date, 'は今日より前の日付にしてください') if date > Date.current
  end

  def bigger_than_before_history
    return if date.nil?

    vaccination = History.find(id).vaccination
    last_letter = vaccination.key[-1]
    return if last_letter == '1'

    vaccinations = Vaccination.where(name: vaccination.name).order(:id)
    vaccinations.each do |vac|
      next unless vac.id < vaccination.id

      history = History.find_by(child_id: child, vaccination_id: vac.id)
      next if history.date.nil?

      return errors.add(:date, 'が前回の期より前の日付になっています') if history.date >= date
    end
  end

  def smaller_than_after_history
    return if date.nil?

    vaccination = Vaccination.find(vaccination_id)
    vaccinations = Vaccination.where(name: vaccination.name).order(:id)

    return if vaccinations.size == 1

    vaccinations.each do |vac|
      next unless vac.id > vaccination.id

      history = History.find_by(child_id: child, vaccination_id: vac.id)
      next if history.date.nil?
      return errors.add(:date, 'が次回の期より後の日付になっています') if history.date <= date
    end
  end

  def self.automatically_vaccinated(vaccination_id, child_id)
    vaccination = Vaccination.find(vaccination_id)
    return if vaccination.key[-1] == '1'

    vaccinations = Vaccination.where(name: vaccination.name)
    the_vaccination_histories = vaccinations.collect do |vac|
      History.find_by(vaccination_id: vac.id, child_id: child_id) if vac.id < vaccination_id
    end
    the_vaccination_histories.compact.each do |history|
      history.update(vaccinated: true) unless History.find_by(id: history.id, child_id: child_id).date
    end
  end
end
