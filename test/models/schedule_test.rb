# frozen_string_literal: true

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test 'future_plans when no vaccinated history' do
    carol = children(:carol)
    vaccinations = Vaccination.all.order(:id)
    expected = { Date.parse('2022-03-03') => [{ name: 'ヒブ', period: '第1期', child: carol }, { name: 'ロタウイルス', period: '1回目', child: carol },
                                              { name: '小児用肺炎球菌', period: '1回目', child: carol }, { name: 'Ｂ型肝炎', period: '1回目', child: carol }],
                 Date.parse('2022-04-03') => [{ name: 'ヒブ', period: '第2期', child: carol }, { name: 'ロタウイルス', period: '2回目', child: carol },
                                              { name: '小児用肺炎球菌', period: '2回目', child: carol },
                                              { name: '４種混合', period: '1回目', child: carol }, { name: 'Ｂ型肝炎', period: '2回目', child: carol }],
                 Date.parse('2022-05-03') => [{ name: 'ヒブ', period: '第3期', child: carol }, { name: 'ロタウイルス', period: '3回目', child: carol },
                                              { name: '小児用肺炎球菌', period: '3回目', child: carol },
                                              { name: '４種混合', period: '2回目', child: carol }],
                 Date.parse('2022-06-03') => [{ name: '４種混合', period: '3回目', child: carol }, { name: 'ＢＣＧ', period: 'nil', child: carol }],
                 Date.parse('2022-08-03') => [{ name: 'Ｂ型肝炎', period: '3回目', child: carol }],
                 Date.parse('2023-01-03') => [{ name: 'おたふくかぜ', period: '1回目', child: carol }, { name: 'ヒブ', period: '第4期', child: carol },
                                              { name: '小児用肺炎球菌', period: '4回目', child: carol },
                                              { name: '水痘', period: '1回目', child: carol }, { name: '麻しん・風しん混合', period: '第1期', child: carol }],
                 Date.parse('2023-06-03') => [{ name: '４種混合', period: '4回目', child: carol }],
                 Date.parse('2023-07-03') => [{ name: '水痘', period: '2回目', child: carol }],
                 Date.parse('2025-01-03') => [{ name: '日本脳炎', period: '1回目', child: carol }],
                 Date.parse('2025-02-03') => [{ name: '日本脳炎', period: '2回目', child: carol }],
                 Date.parse('2026-02-03') => [{ name: '日本脳炎', period: '3回目', child: carol }],
                 Date.parse('2027-04-01')..Date.parse('2028-03-31') => [{ name: 'おたふくかぜ', period: '2回目', child: carol },
                                                                        { name: '麻しん・風しん混合', period: '第2期', child: carol }],
                 Date.parse('2031-01-03') => [{ name: '日本脳炎', period: '4回目', child: carol }],
                 Date.parse('2033-01-03') => [{ name: '２種混合', period: '1回目', child: carol }] }
    assert_equal expected, Schedule.future_plans(vaccinations, carol)
  end

  test 'future_plans when vaccinated history' do
    dave = children(:dave)
    vaccinations = Vaccination.all.order(:id)
    expected = { Date.parse('2021-09-21') => [{ name: 'ヒブ', period: '第1期', child: dave }, { name: '小児用肺炎球菌', period: '1回目', child: dave },
                                              { name: 'Ｂ型肝炎', period: '1回目', child: dave }],
                 Date.parse('2021-10-21') => [{ name: 'ヒブ', period: '第2期', child: dave }, { name: '小児用肺炎球菌', period: '2回目', child: dave },
                                              { name: '４種混合', period: '1回目', child: dave }, { name: 'Ｂ型肝炎', period: '2回目', child: dave }],
                 Date.parse('2021-11-18') => [{ name: 'ロタウイルス', period: '3回目', child: dave }],
                 Date.parse('2021-11-21') => [{ name: 'ヒブ', period: '第3期', child: dave }, { name: '小児用肺炎球菌', period: '3回目', child: dave },
                                              { name: '４種混合', period: '2回目', child: dave }],
                 Date.parse('2021-12-21') => [{ name: '４種混合', period: '3回目', child: dave }, { name: 'ＢＣＧ', period: 'nil', child: dave }],
                 Date.parse('2022-02-21') => [{ name: 'Ｂ型肝炎', period: '3回目', child: dave }],
                 Date.parse('2022-07-21') => [{ name: 'おたふくかぜ', period: '1回目', child: dave }, { name: 'ヒブ', period: '第4期', child: dave },
                                              { name: '小児用肺炎球菌', period: '4回目', child: dave },
                                              { name: '水痘', period: '1回目', child: dave }, { name: '麻しん・風しん混合', period: '第1期', child: dave }],
                 Date.parse('2022-12-21') => [{ name: '４種混合', period: '4回目', child: dave }],
                 Date.parse('2023-01-21') => [{ name: '水痘', period: '2回目', child: dave }],
                 Date.parse('2024-07-21') => [{ name: '日本脳炎', period: '1回目', child: dave }],
                 Date.parse('2024-08-21') => [{ name: '日本脳炎', period: '2回目', child: dave }],
                 Date.parse('2025-08-21') => [{ name: '日本脳炎', period: '3回目', child: dave }],
                 Date.parse('2027-04-01')..Date.parse('2028-03-31') => [{ name: 'おたふくかぜ', period: '2回目', child: dave },
                                                                        { name: '麻しん・風しん混合', period: '第2期', child: dave }],
                 Date.parse('2030-07-21') => [{ name: '日本脳炎', period: '4回目', child: dave }],
                 Date.parse('2032-07-21') => [{ name: '２種混合', period: '1回目', child: dave }] }
    assert_equal expected, Schedule.future_plans(vaccinations, dave)
  end

  test 'future_plans when plus vaccinated history' do
    dave = children(:dave)
    vaccinations = Vaccination.all.order(:id)

    hib_second = vaccinations(:"#{hib_2}")
    history = History.new(child: dave, vaccination: hib_second, date: Date.parse('2021-10-22'))
    history.save
    History.automatically_vaccinated(hib_second.id, dave.id)
    # ヒブ2回目と3回目の間隔は27日なのでヒブ2回目 + 27日分で割り出せる。連動して4回目も変更になるが、3回目から60日経過&&1歳以降なので1歳の誕生日からは動かない
    expected = { Date.parse('2021-09-21') => [{ name: '小児用肺炎球菌', period: '1回目', child: dave }, { name: 'Ｂ型肝炎', period: '1回目', child: dave }],
                 Date.parse('2021-10-21') => [{ name: '小児用肺炎球菌', period: '2回目', child: dave },
                                              { name: '４種混合', period: '1回目', child: dave }, { name: 'Ｂ型肝炎', period: '2回目', child: dave }],
                 Date.parse('2021-11-18') => [{ name: 'ヒブ', period: '第3期', child: dave }, { name: 'ロタウイルス', period: '3回目', child: dave }],
                 Date.parse('2021-11-21') => [{ name: '小児用肺炎球菌', period: '3回目', child: dave },
                                              { name: '４種混合', period: '2回目', child: dave }],
                 Date.parse('2021-12-21') => [{ name: '４種混合', period: '3回目', child: dave }, { name: 'ＢＣＧ', period: 'nil', child: dave }],
                 Date.parse('2022-02-21') => [{ name: 'Ｂ型肝炎', period: '3回目', child: dave }],
                 Date.parse('2022-07-21') => [{ name: 'おたふくかぜ', period: '1回目', child: dave }, { name: 'ヒブ', period: '第4期', child: dave },
                                              { name: '小児用肺炎球菌', period: '4回目', child: dave },
                                              { name: '水痘', period: '1回目', child: dave }, { name: '麻しん・風しん混合', period: '第1期', child: dave }],
                 Date.parse('2022-12-21') => [{ name: '４種混合', period: '4回目', child: dave }],
                 Date.parse('2023-01-21') => [{ name: '水痘', period: '2回目', child: dave }],
                 Date.parse('2024-07-21') => [{ name: '日本脳炎', period: '1回目', child: dave }],
                 Date.parse('2024-08-21') => [{ name: '日本脳炎', period: '2回目', child: dave }],
                 Date.parse('2025-08-21') => [{ name: '日本脳炎', period: '3回目', child: dave }],
                 Date.parse('2027-04-01')..Date.parse('2028-03-31') => [{ name: 'おたふくかぜ', period: '2回目', child: dave },
                                                                        { name: '麻しん・風しん混合', period: '第2期', child: dave }],
                 Date.parse('2030-07-21') => [{ name: '日本脳炎', period: '4回目', child: dave }],
                 Date.parse('2032-07-21') => [{ name: '２種混合', period: '1回目', child: dave }] }
    assert_equal expected, Schedule.future_plans(vaccinations, dave)
  end
end
