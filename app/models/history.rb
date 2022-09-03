# frozen_string_literal: true

class History < ApplicationRecord
  belongs_to :child
  belongs_to :vaccination

  validates :vaccination_id, presence: true, uniqueness: { scope: :child }
  validate :history_before_today
  validate :bigger_than_before_history
  validate :smaller_than_after_history
  validate :date_or_vaccinatied

  after_destroy :after_vaccinated_true
  after_destroy :before_vaccinated_false

  class << self
    def automatically_vaccinated(vaccination, child)
      return if vaccination.key[-1] == '1'

      vaccinations = Vaccination.where(name: vaccination.name)
      vaccinations.each do |vac|
        next unless vac.key < vaccination.key

        history = History.find_by(vaccination_id: vac.id, child_id: child.id)
        if history.nil?
          new_history = History.new
          new_history.update(vaccination_id: vac.id, vaccinated: true, child_id: child.id)
        end
      end
    end
  end

  private

  def history_before_today
    return if date.nil?

    errors.add(:date, 'は今日より前の日付にしてください') if date > Date.current
  end

  def bigger_than_before_history
    return if date.nil?

    last_letter = vaccination.key[-1]
    return if last_letter == '1'

    vaccinations = Vaccination.where(name: vaccination.name).order(:key)
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

    vaccinations = Vaccination.where(name: vaccination.name).order(:key)

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
    errors.add(:date, 'が入力されていません') if date.nil? && !vaccinated
  end

  def after_vaccinated_true
    vaccinations = Vaccination.where(name: vaccination.name).order(key: :desc)
    return if vaccinations.size == 1
    histories = vaccinations.map do |vac|
      History.find_by(child_id: child, vaccination_id: vac.id)
    end&.compact

    biggest_history = histories.max_by{_1.date.to_s}
    return if biggest_history&.date.nil?
    vaccinations = Vaccination.where(name: biggest_history.vaccination.name)
      vaccinations.each do |vac|
        next unless vac.key <  biggest_history.vaccination.key

        history = History.find_by(vaccination_id: vac.id, child_id: child.id)
        if history.nil?
          new_history = History.new
          new_history.update(vaccination_id: vac.id, vaccinated: true, child_id: child.id)
        end
      end
  end

  def before_vaccinated_false
    vaccinations = Vaccination.where(name: vaccination.name).order(key: :desc)

    return if vaccinations.size == 1
    vaccinations.each do |vac|

      next if vac.id >= vaccination.id

      history = History.find_by(child_id: child, vaccination_id: vac.id)
      next if history.nil?
      return if history&.date

      history.destroy!
    end
  end
end
