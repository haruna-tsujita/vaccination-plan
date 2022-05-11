# frozen_string_literal: true

class History < ApplicationRecord
  belongs_to :child
  belongs_to :vaccination

  validates :child_id, presence: true
  validates :vaccination_id, presence: true, uniqueness: { scope: :child }
  validate :history_before_today
  validate :bigger_than_before_history
  validate :smaller_than_after_history
  validate :date_or_vaccinatied

  def history_before_today
    return if date.nil?

    errors.add(:date, 'は今日より前の日付にしてください') if date > Date.current
  end

  def bigger_than_before_history
    return if date.nil?

    vaccination = Vaccination.find(vaccination_id)
    last_letter = vaccination.key[-1]
    return if last_letter == '1'

    vaccinations = Vaccination.where(name: vaccination.name).order(:id)
    vaccinations.each do |vac|
      next unless vac.id < vaccination.id

      history = History.find_by(child_id: child, vaccination_id: vac.id)
      next unless history
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
      next unless history
      next if history.date.nil?
      return errors.add(:date, 'が次回の期より後の日付になっています') if history.date <= date
    end
  end

  def date_or_vaccinatied
    errors.add(:date, 'が入力されていません') if date.nil? && vaccinated.nil?
  end

  def self.automatically_vaccinated(vaccination_id, child_id)
    vaccination = Vaccination.find(vaccination_id)
    return if vaccination.key[-1] == '1'

    vaccinations = Vaccination.where(name: vaccination.name)
    vaccinations.each do |vac|
      next unless vac.key < vaccination.key

      history = History.find_by(vaccination_id: vac.id, child_id: child_id)
      if history.nil?
        history = History.new
        history.update(vaccination_id: vac.id, vaccinated: true, child_id: child_id)
      end
    end
  end
end
