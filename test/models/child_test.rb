# frozen_string_literal: true

require 'test_helper'

class ChildTest < ActiveSupport::TestCase
  test 'calc_moon_age birthday is same year' do
    today = Date.parse('2022-04-22')
    birthday = Date.parse('2022-01-01')
    assert_equal '0才 3ヶ月', Child.calc_moon_age(today, birthday)
  end

  test 'calc_moon_age birthday is different year' do
    today = Date.parse('2022-04-22')
    birthday = Date.parse('2021-12-31')
    assert_equal '0才 3ヶ月', Child.calc_moon_age(today, birthday)
  end

  test 'calc_moon_age birthday is different year and early month' do
    today = Date.parse('2022-04-22')
    birthday = Date.parse('2021-01-01')
    assert_equal '1才 3ヶ月', Child.calc_moon_age(today, birthday)
  end
end
