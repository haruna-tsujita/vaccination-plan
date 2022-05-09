# frozen_string_literal: true

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test 'future_plans when no vaccinated history' do
    carol = children(:carol)
    histories = History.where(child: carol)
    expexted = { Date.parse('2022-03-03') => [{ name: 'ヒブ', period: '第1期', child: carol }, { name: 'ロタウイルス', period: '1回目', child: carol }],
                 Date.parse('2022-04-03') => [{ name: 'ヒブ', period: '第2期', child: carol }, { name: 'ロタウイルス', period: '2回目', child: carol }],
                 Date.parse('2022-05-03') => [{ name: 'ヒブ', period: '第3期', child: carol }, { name: 'ロタウイルス', period: '3回目', child: carol }],
                 Date.parse('2023-01-03') => [{ name: 'ヒブ', period: '第4期', child: carol }] }
    assert_equal expexted, Schedule.future_plans(histories, carol)
  end

  test 'future_plans when vaccinated history' do
    dave = children(:dave)
    histories = History.where(child: dave).order(:vaccination_id)
    expected = {  Date.parse('2021-09-21') => [{name: 'ヒブ', period: "第1期", child: dave}, {name: '小児用肺炎球菌', period: "1回目", child: dave}],
      Date.parse('2021-10-21') => [{name: 'ヒブ', period: "第2期", child: dave}, {name: '小児用肺炎球菌', period: "2回目", child: dave}],
      Date.parse('2021-11-18') => [{name: 'ロタウイルス', period: "3回目", child: dave}],
      Date.parse('2021-11-21') => [{name: 'ヒブ', period: "第3期", child: dave}, {name: '小児用肺炎球菌', period: "3回目", child: dave}],
      Date.parse('2022-07-21') => [{name: 'ヒブ', period: "第4期", child: dave}, {name: '小児用肺炎球菌', period: "4回目", child: dave}, {name: '水痘', period: "1回目", child: dave}],
      Date.parse('2023-01-21') => [{name: '水痘', period: "2回目", child: dave}]}
    assert_equal expected, Schedule.future_plans(histories, dave)
  end
end
