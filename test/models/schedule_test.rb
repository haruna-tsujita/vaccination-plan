# frozen_string_literal: true

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test 'future_plans' do
    carol = children(:carol)
    histories = History.where(child: carol)
    expexted = { Date.parse('2022-03-03') => [{ name: 'ヒブ', period: '第1期', child: carol }, { name: 'ロタウイルス', period: '1回目', child: carol }],
                 Date.parse('2022-04-03') => [{ name: 'ヒブ', period: '第2期', child: carol }, { name: 'ロタウイルス', period: '2回目', child: carol }],
                 Date.parse('2022-05-03') => [{ name: 'ヒブ', period: '第3期', child: carol }, { name: 'ロタウイルス', period: '3回目', child: carol }],
                 Date.parse('2023-01-03') => [{ name: 'ヒブ', period: '第4期', child: carol }] }
    assert_equal expexted, Schedule.future_plans(histories, carol)
  end
end
