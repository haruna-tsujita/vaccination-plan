# frozen_string_literal: true

class Family
  def self.family_schedule(_children, histories)
    all_histories = histories.map do |child_histories|
      child = child_histories[0].child
      Schedule.future_plans(child_histories, child)
    end

    merge_history = {}.merge(*all_histories) { |_key, v1, v2| v1 + v2 }
    sort_plan = merge_history.sort_by do |a, _b|
      [Date, String].include?(a.class) ? a : a.first
    end.to_h
    sort_plan.each_value do |b|
      b.sort_by do |x|
        x[:child]
        x[:name]
      end
    end.to_h
  end

  def self.vaccination_date_before_today(children, histories)
    Family.family_schedule(children, histories).select.with_index do |array, index|
      date = array[0]
      {date => array[1]} if (date.instance_of?(Range) && date.first <= Time.current) || (date.instance_of?(Date) && date <= Time.current)
    end
  end
end
