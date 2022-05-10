# frozen_string_literal: true

class Family
  def self.family_schedule(vaccinations, children)
    all_histories = children.map do |child|
      Schedule.future_plans(vaccinations, child)
    end

    merge_history = {}.merge(*all_histories) { |_key, histories1, histories2| histories1 + histories2 }
    sort_plan = merge_history.sort_by do |date, _vaccination|
      [Date, String].include?(date.class) ? date : date.first
    end.to_h
    sort_plan.each_value do |vacs|
      vacs.sort_by! do |vac|
        vac[:child]
        vac[:name]
      end
    end.to_h
  end

  def self.vaccination_date_before_today(histories, children)
    Family.family_schedule(histories, children).select do |date, vaccination|
      { date => vaccination } if (date.instance_of?(Range) && date.first <= Time.current) || (date.instance_of?(Date) && date <= Time.current)
    end
  end
end
