# frozen_string_literal: true

class Family
  class << self
    def family_schedule(vaccinations, children)
      all_schedules = children.map do |child|
        Schedule.future_plans(vaccinations, child)
      end

      merge_history = {}.merge(*all_schedules) { |_key, schedules1, schedules2| schedules1 + schedules2 }
      merge_history.sort_by do |date, _vaccination|
        [Date, String].include?(date.class) ? date : date.first
      end.to_h
    end

    def vaccination_date_before_today(vaccinations, children, today)
      family_schedule(vaccinations, children).select do |date, vaccination|
        { date => vaccination } if (date.instance_of?(Range) && date.first <= today) || (date.instance_of?(Date) && date <= today)
      end
    end
  end
end
