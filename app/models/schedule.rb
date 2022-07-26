# frozen_string_literal: true

class Schedule < ApplicationRecord
  class << self
    def future_plans(vaccinations, child)
      sort_by_date_vaccination_days =
        new_schedules(vaccinations, child).sort_by do |day|
          [Date, String].include?(day[:date].class) ? day[:date] : day[:date].first
        end
      combined_name_and_date = sort_by_date_vaccination_days.each_with_object({}) do |day, ret|
        ret[day[:vaccinations]] = day[:date]
      end
      combined_name_and_date.each_key.group_by { |date| combined_name_and_date[date] }.each_value { |ary| ary.sort_by! { |hash| hash[:name] } }
    end

    def number_of_days_elapsed(start_day)
      if TimeDifference.between(start_day, Date.current).in_days > 30
        "#{TimeDifference.between(start_day, Date.current).in_months.floor}ヶ月経過"
      else
        "#{TimeDifference.between(start_day, Date.current).in_days.floor}日経過"
      end
    end

    def how_many_days_within_a_week(date)
      "あと#{TimeDifference.between(date, Date.current).in_days.floor}日" if date <= (Date.current + 7.days)
    end

    def next_plan(vaccination, child)
      last_letter = vaccination.key[-1]
      case last_letter
      when '1'
        calc_recommended_date(vaccination: vaccination, birthday: child.birthday)
      else
        before_vac_key = vaccination.key.gsub(/[2-4]/) { |num| (num.to_i - 1).to_s }
        before_vac_id = Vaccination.find_by(key: before_vac_key).id
        before_history = History.find_by(vaccination_id: before_vac_id, child_id: child.id)
        calc_for_each_vaccinated_status(before_history: before_history, vaccination: vaccination, child: child)
      end
    end

    private

    def new_schedules(vaccinations, child)
      histories = child.histories
      vaccinations.map do |vaccination|
        next if histories.find { |history| history.vaccination.id == vaccination.id }

        { vaccinations: { name: vaccination.name.to_s, period: vaccination.period.to_s, child: child }, date: next_plan(vaccination, child) }
      end.compact
    end

    def calc_for_each_vaccinated_status(before_history:, vaccination:, child:)
      if before_history.nil? || (before_history.date.nil? && !before_history.vaccinated)
        calc_recommended_date(vaccination: vaccination, birthday: child.birthday)
      else
        next_day = JpVaccination.next_day(vaccination.key, before_history.date.strftime('%Y-%m-%d'), child.birthday.strftime('%Y-%m-%d'))[:date]
        next_day.instance_of?(String) ? pre_school_year(child.birthday) : next_day
      end
    end

    def calc_recommended_date(vaccination:, birthday:)
      if JpVaccination.find(vaccination.key).recommended.class != Hash
        pre_school_year(birthday)
      elsif JpVaccination.find(vaccination.key).recommended[:month]
        birthday.next_month(JpVaccination.find(vaccination.key).recommended[:month])
      elsif JpVaccination.find(vaccination.key).recommended[:year]
        birthday.next_year(JpVaccination.find(vaccination.key).recommended[:year])
      end
    end

    def pre_school_year(birthday)
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
end
