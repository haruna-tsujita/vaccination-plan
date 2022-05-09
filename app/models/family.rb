# frozen_string_literal: true

class Family
  def self.family_schedule(histories)
    all_histories = histories.map do |child_histories|
      child = child_histories[0].child
      Schedule.future_plans(child_histories, child)
    end

    merge_history = {}.merge(*all_histories) { |_key, histories1, histories2| histories1 + histories2 }
    sort_plan = merge_history.sort_by do |date, _vaccination|
      [Date, String].include?(date.class) ? date : date.first
    end.to_h
    sort_plan.each_value do |vaccinations|
      vaccinations.sort_by do |vaccination|
        vaccination[:child]
        vaccination[:name]
      end
    end.to_h
  end

  def self.vaccination_date_before_today(histories)
    Family.family_schedule(histories).select do |date, vaccination|
      { date => vaccination } if (date.instance_of?(Range) && date.first <= Time.current) || (date.instance_of?(Date) && date <= Time.current)
    end
  end
end
