# frozen_string_literal: true

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test 'future_plans' do
    carol = children(:carol)
    histories = History.where(child: carol)
    expexted = { Date.parse('2022-03-03') => ['ヒブ 第1期', 'ロタウイルス 1回目'], Date.parse('2022-04-03') => ['ヒブ 第2期', 'ロタウイルス 2回目'],
                 Date.parse('2022-05-03') => ['ヒブ 第3期', 'ロタウイルス 3回目'], Date.parse('2023-01-03') => ['ヒブ 第4期'] }
    assert_equal expexted, Schedule.future_plans(histories, carol)
  end
end
