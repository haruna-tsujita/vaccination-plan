# frozen_string_literal: true

require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  test 'family schedule' do
    dave = children(:dave)
    frank = children(:frank)
    children = [dave, frank]
    vaccinations = Vaccination.all
    expected = { Date.parse('2019-11-10') => [{ name: 'ヒブ', period: '第1期', child: frank }, { name: 'ロタウイルス', period: '1回目', child: frank }, { name: '小児用肺炎球菌', period: '1回目', child: frank }, { name: 'Ｂ型肝炎', period: '1回目', child: frank }],
                 Date.parse('2019-12-10') => [{ name: 'ヒブ', period: '第2期', child: frank }, { name: 'ロタウイルス', period: '2回目', child: frank }, { name: '小児用肺炎球菌', period: '2回目', child: frank },
                                              { name: '４種混合', period: '1回目', child: frank }, { name: 'Ｂ型肝炎', period: '2回目', child: frank }],
                 Date.parse('2020-01-10') => [{ name: 'ヒブ', period: '第3期', child: frank }, { name: 'ロタウイルス', period: '3回目', child: frank }, { name: '小児用肺炎球菌', period: '3回目', child: frank },
                                              { name: '４種混合', period: '2回目', child: frank }],
                 Date.parse('2020-02-10') => [{ name: '４種混合', period: '3回目', child: frank }, { name: 'ＢＣＧ', period: 'nil', child: frank }],
                 Date.parse('2020-04-10') => [{ name: 'Ｂ型肝炎', period: '3回目', child: frank }],
                 Date.parse('2020-09-10') => [{ name: 'おたふくかぜ', period: '1回目', child: frank }, { name: 'ヒブ', period: '第4期', child: frank }, { name: '小児用肺炎球菌', period: '4回目', child: frank },
                                              { name: '水痘', period: '1回目', child: frank }, { name: '麻しん・風しん混合', period: '第1期', child: frank }],
                 Date.parse('2021-02-10') => [{ name: '４種混合', period: '4回目', child: frank }],
                 Date.parse('2021-03-10') => [{ name: '水痘', period: '2回目', child: frank }],
                 Date.parse('2021-09-21') => [{ name: 'ヒブ', period: '第1期', child: dave }, { name: '小児用肺炎球菌', period: '1回目', child: dave }, { name: 'Ｂ型肝炎', period: '1回目', child: dave }],
                 Date.parse('2021-10-21') => [{ name: 'ヒブ', period: '第2期', child: dave }, { name: '小児用肺炎球菌', period: '2回目', child: dave },
                                              { name: '４種混合', period: '1回目', child: dave }, { name: 'Ｂ型肝炎', period: '2回目', child: dave }],
                 Date.parse('2021-11-18') => [{ name: 'ロタウイルス', period: '3回目', child: dave }],
                 Date.parse('2021-11-21') => [{ name: 'ヒブ', period: '第3期', child: dave }, { name: '小児用肺炎球菌', period: '3回目', child: dave },
                                              { name: '４種混合', period: '2回目', child: dave }],
                 Date.parse('2021-12-21') => [{ name: '４種混合', period: '3回目', child: dave }, { name: 'ＢＣＧ', period: 'nil', child: dave }],
                 Date.parse('2022-02-21') => [{ name: 'Ｂ型肝炎', period: '3回目', child: dave }],
                 Date.parse('2022-07-21') => [{ name: 'おたふくかぜ', period: '1回目', child: dave }, { name: 'ヒブ', period: '第4期', child: dave }, { name: '小児用肺炎球菌', period: '4回目', child: dave },
                                              { name: '水痘', period: '1回目', child: dave }, { name: '麻しん・風しん混合', period: '第1期', child: dave }],
                 Date.parse('2022-09-10') => [{ name: '日本脳炎', period: '1回目', child: frank }],
                 Date.parse('2022-10-10') => [{ name: '日本脳炎', period: '2回目', child: frank }],
                 Date.parse('2022-12-21') => [{ name: '４種混合', period: '4回目', child: dave }],
                 Date.parse('2023-01-21') => [{ name: '水痘', period: '2回目', child: dave }],
                 Date.parse('2023-10-10') => [{ name: '日本脳炎', period: '3回目', child: frank }],
                 Date.parse('2024-07-21') => [{ name: '日本脳炎', period: '1回目', child: dave }],
                 Date.parse('2024-08-21') => [{ name: '日本脳炎', period: '2回目', child: dave }],
                 Date.parse('2025-04-01')..Date.parse('2026-03-31') => [{ name: 'おたふくかぜ', period: '2回目', child: frank },
                                                                        { name: '麻しん・風しん混合', period: '第2期', child: frank }],
                 Date.parse('2025-08-21') => [{ name: '日本脳炎', period: '3回目', child: dave }],
                 Date.parse('2027-04-01')..Date.parse('2028-03-31') => [{ name: 'おたふくかぜ', period: '2回目', child: dave },
                                                                        { name: '麻しん・風しん混合', period: '第2期', child: dave }],
                 Date.parse('2028-09-10') => [{ name: '日本脳炎', period: '4回目', child: frank }],
                 Date.parse('2030-07-21') => [{ name: '日本脳炎', period: '4回目', child: dave }],
                 Date.parse('2030-09-10') => [{ name: '２種混合', period: '1回目', child: frank }],
                 Date.parse('2032-07-21') => [{ name: '２種混合', period: '1回目', child: dave }]}

    assert_equal expected, Family.family_schedule(vaccinations, children)
  end

  test 'vaccination_date_before_today' do
    dave = children(:dave)
    frank = children(:frank)
    children = [dave, frank]
    vaccinations = Vaccination.all.order(:id)
    # expected = {
    #   Date.parse('2019-11-10') => [{ name: 'ヒブ', period: '第1期', child: frank }, { name: 'ロタウイルス', period: '1回目', child: frank },
    #                                { name: '小児用肺炎球菌', period: '1回目', child: frank }],
    #   Date.parse('2019-12-10') => [{ name: 'ヒブ', period: '第2期', child: frank }, { name: 'ロタウイルス', period: '2回目', child: frank },
    #                                { name: '小児用肺炎球菌', period: '2回目', child: frank }],
    #   Date.parse('2020-01-10') => [{ name: 'ヒブ', period: '第3期', child: frank }, { name: 'ロタウイルス', period: '3回目', child: frank },
    #                                { name: '小児用肺炎球菌', period: '3回目', child: frank }],
    #   Date.parse('2020-09-10') => [{ name: 'ヒブ', period: '第4期', child: frank }, { name: '小児用肺炎球菌', period: '4回目', child: frank },
    #                                { name: '水痘', period: '1回目', child: frank }],
    #   Date.parse('2021-03-10') => [{ name: '水痘', period: '2回目', child: frank }],
    #   Date.parse('2021-09-21') => [{ name: 'ヒブ', period: '第1期', child: dave }, { name: '小児用肺炎球菌', period: '1回目', child: dave }],
    #   Date.parse('2021-10-21') => [{ name: 'ヒブ', period: '第2期', child: dave }, { name: '小児用肺炎球菌', period: '2回目', child: dave }],
    #   Date.parse('2021-11-18') => [{ name: 'ロタウイルス', period: '3回目', child: dave }],
    #   Date.parse('2021-11-21') => [{ name: 'ヒブ', period: '第3期', child: dave }, { name: '小児用肺炎球菌', period: '3回目', child: dave }]
    # }

    assert_equal expected, Family.vaccination_date_before_today(vaccinations, children)
  end
end
