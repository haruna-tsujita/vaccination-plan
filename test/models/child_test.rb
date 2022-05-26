# frozen_string_literal: true

require 'test_helper'

class ChildTest < ActiveSupport::TestCase
  test 'calc_moon_age birthday is same year' do
    today = Date.parse('2018-12-22')
    child = children(:issac)
    assert_equal '0才 1ヶ月', child.calc_moon_age(today)
  end

  test 'calc_moon_age birthday is different year' do
    today = Date.parse('2019-04-22')
    child = children(:issac)
    assert_equal '0才 5ヶ月', child.calc_moon_age(today)
  end

  test 'calc_moon_age birthday is different year and early month' do
    today = Date.parse('2021-04-22')
    child = children(:eve)
    assert_equal '1才 1ヶ月', child.calc_moon_age(today)
  end
end
