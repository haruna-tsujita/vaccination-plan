# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class Optionstest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @alice = users(:alice)
    login_as(@alice, scope: :user)
  end

  test 'update_option_mumps_false' do
    setup
    carol = children(:carol)
    option = options(:carol_option)
    assert option.mumps
    visit "/children/#{carol.id}/edit"
    uncheck 'おたふくかぜを接種する'
    click_on '保存'
    option.reload
    assert_not option.mumps
  end

  test 'update_option_rotateq_false' do
    setup
    carol = children(:carol)
    option = options(:carol_option)
    assert option.rotateq
    visit "/children/#{carol.id}/edit"
    uncheck 'ロタテック(5価ロタウイルスワクチン)を接種する'
    click_on '保存'
    option.reload
    assert_not option.rotateq
  end
end
