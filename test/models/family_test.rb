# frozen_string_literal: true

require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  test 'family schedule' do
    dave = children(:dave)
    frank = children(:frank)
    histories = users(:bob).children.map(&:histories)
    expected = {
      Date.parse('2019-11-10') => [{ name: 'ヒブ', period: '第1期', child: frank }, { name: 'ロタウイルス', period: '1回目', child: frank },
                                   { name: '小児用肺炎球菌', period: '1回目', child: frank }],
      Date.parse('2019-12-10') => [{ name: 'ヒブ', period: '第2期', child: frank }, { name: 'ロタウイルス', period: '2回目', child: frank },
                                   { name: '小児用肺炎球菌', period: '2回目', child: frank }],
      Date.parse('2020-01-10') => [{ name: 'ヒブ', period: '第3期', child: frank }, { name: 'ロタウイルス', period: '3回目', child: frank },
                                   { name: '小児用肺炎球菌', period: '3回目', child: frank }],
      Date.parse('2020-09-10') => [{ name: 'ヒブ', period: '第4期', child: frank }, { name: '小児用肺炎球菌', period: '4回目', child: frank },
                                   { name: '水痘', period: '1回目', child: frank }],
      Date.parse('2021-03-10') => [{ name: '水痘', period: '2回目', child: frank }],
      Date.parse('2021-09-21') => [{ name: 'ヒブ', period: '第1期', child: dave }, { name: '小児用肺炎球菌', period: '1回目', child: dave }],
      Date.parse('2021-10-21') => [{ name: 'ヒブ', period: '第2期', child: dave }, { name: '小児用肺炎球菌', period: '2回目', child: dave }],
      Date.parse('2021-11-18') => [{ name: 'ロタウイルス', period: '3回目', child: dave }],
      Date.parse('2021-11-21') => [{ name: 'ヒブ', period: '第3期', child: dave }, { name: '小児用肺炎球菌', period: '3回目', child: dave }],
      Date.parse('2022-07-21') => [{ name: 'ヒブ', period: '第4期', child: dave }, { name: '小児用肺炎球菌', period: '4回目', child: dave },
                                   { name: '水痘', period: '1回目', child: dave }],
      Date.parse('2023-01-21') => [{ name: '水痘', period: '2回目', child: dave }]
    }

    assert_equal expected, Family.family_schedule(histories)
  end

  test 'vaccination_date_before_today' do
    dave = children(:dave)
    frank = children(:frank)
    histories = users(:bob).children.map(&:histories)
    expected = {
      Date.parse('2019-11-10') => [{ name: 'ヒブ', period: '第1期', child: frank }, { name: 'ロタウイルス', period: '1回目', child: frank },
                                   { name: '小児用肺炎球菌', period: '1回目', child: frank }],
      Date.parse('2019-12-10') => [{ name: 'ヒブ', period: '第2期', child: frank }, { name: 'ロタウイルス', period: '2回目', child: frank },
                                   { name: '小児用肺炎球菌', period: '2回目', child: frank }],
      Date.parse('2020-01-10') => [{ name: 'ヒブ', period: '第3期', child: frank }, { name: 'ロタウイルス', period: '3回目', child: frank },
                                   { name: '小児用肺炎球菌', period: '3回目', child: frank }],
      Date.parse('2020-09-10') => [{ name: 'ヒブ', period: '第4期', child: frank }, { name: '小児用肺炎球菌', period: '4回目', child: frank },
                                   { name: '水痘', period: '1回目', child: frank }],
      Date.parse('2021-03-10') => [{ name: '水痘', period: '2回目', child: frank }],
      Date.parse('2021-09-21') => [{ name: 'ヒブ', period: '第1期', child: dave }, { name: '小児用肺炎球菌', period: '1回目', child: dave }],
      Date.parse('2021-10-21') => [{ name: 'ヒブ', period: '第2期', child: dave }, { name: '小児用肺炎球菌', period: '2回目', child: dave }],
      Date.parse('2021-11-18') => [{ name: 'ロタウイルス', period: '3回目', child: dave }],
      Date.parse('2021-11-21') => [{ name: 'ヒブ', period: '第3期', child: dave }, { name: '小児用肺炎球菌', period: '3回目', child: dave }]
    }

    assert_equal expected, Family.vaccination_date_before_today(histories)
  end
end
