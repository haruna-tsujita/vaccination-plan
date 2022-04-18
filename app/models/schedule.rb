# frozen_string_literal: true

class Schedule < ApplicationRecord
  def self.schedules(histories, child)
    schedules = []
    histories.each_with_index do |history, idx|
    unless history.vaccinated || history.date
      vaccination =  Vaccination.find(history.vaccination_id)
      last_letter = vaccination.key[-1]
      date =
        unless last_letter == '1'
          before_vac_key = vaccination.key.gsub(/[2-4]/){ |num| "#{num.to_i - 1}"}
          before_vac_id = Vaccination.find_by(key: before_vac_key).id
          before_history = History.find_by(vaccination_id: before_vac_id, child_id: child.id)
          if before_history.date || before_history.vaccinated
            if JpVaccination.find(vaccination.key).recommended.class != Hash
              pre_school_year(child.birthday)
            elsif JpVaccination.find(vaccination.key).recommended[:month]
              before_history.date >> JpVaccination.find(vaccination.key).recommended[:month]
            end
          else
            if JpVaccination.find(vaccination.key).recommended.class != Hash
              pre_school_year(child.birthday)
            elsif JpVaccination.find(vaccination.key).recommended[:month]
              child.birthday >> JpVaccination.find(vaccination.key).recommended[:month]
            elsif JpVaccination.find(vaccination.key).recommended[:year]
              child.birthday >> JpVaccination.find(vaccination.key).recommended[:year] * 12
            end
          end
        else
          if JpVaccination.find(vaccination.key).recommended[:month]
            child.birthday >> JpVaccination.find(vaccination.key).recommended[:month]
          elsif JpVaccination.find(vaccination.key).recommended[:year]
            child.birthday >> JpVaccination.find(vaccination.key).recommended[:year] * 12
          end
        end
      schedules << {name: vaccination.name + vaccination.period, date: date}
      end
    end
    schedules
  end

  def self.recommended_schedules(histories, child)
    sort_by_date_vaccination_days =
      schedules(histories, child).sort_by do |day|
        [Date, String].include?(day[:date].class) ? day[:date] : day[:date].first
      end
    combined_name_and_date = sort_by_date_vaccination_days.each_with_object({}) do |day, ret|
      ret[day[:name]] = day[:date]
    end
    combined_name_and_date.each_key.group_by { |date| combined_name_and_date[date] }.each_value(&:sort!)
  end

  def self.pre_school_year(birthday)
    fifth_birthday = birthday + 5.years
    year = case fifth_birthday.month
            when 1..3
              fifth_birthday.year
            when 4
              fifth_birthday.day == 1 ? fifth_birthday.year : fifth_birthday.year.next
            when 5..12
              fifth_birthday.year.next
            end
    Date.new(year, 4, 1)..Date.new(year.next, 3, 31)
  end
end
