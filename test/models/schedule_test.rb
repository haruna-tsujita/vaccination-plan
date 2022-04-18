# frozen_string_literal: true

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test 'future_plans' do
    carol = children(:carol)
    histories = History.where(child: carol)
    expexted = { Date.parse('2022-03-03') => %w[ヒブ第1期 ロタウイルス1回目], Date.parse('2022-04-03') => %w[ヒブ第2期 ロタウイルス2回目],
                 Date.parse('2022-05-03') => %w[ヒブ第3期 ロタウイルス3回目], Date.parse('2023-01-03') => ['ヒブ第4期'] }
    assert_equal expexted, Schedule.future_plans(histories, carol)
  end
end
