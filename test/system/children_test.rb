# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class Childrentest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:Alice)
    login_as(@user, scope: :user)
  end

  test 'after_login_visit_children_index' do
    setup
    visit children_path
    assert_text 'Children#index'
  end

  test 'not_login_do_not_visit_children_index' do
    setup
    logout
    visit children_path
    assert_text 'ログイン'
  end

  test 'create_new_child' do
    setup
    visit new_child_path
    fill_in 'Name', with: 'hanako'
    fill_in 'Birthday', with: Date.parse('2022-03-01')
    click_on '登録する'
    assert_text 'hanako'
    assert_text '2022年03月01日'
  end

  test 'update_new_child' do
    setup
    visit "/children/#{children(:hanako).id}/edit"
    fill_in 'Name', with: '桃子'
    fill_in 'Birthday', with: Date.parse('2022-03-03')
    click_on '更新する'
    assert_text '桃子'
    assert_text '2022年03月03日'
  end

  test 'name_and_birthday_is_valid' do
    setup
    visit new_child_path
    fill_in 'Name', with: nil
    fill_in 'Birthday', with: nil
    click_on '登録する'
    assert_text 'Nameを入力してください'
    assert_text 'Birthdayを入力してください'
  end

  test 'birthday_is_not_after_today' do
    setup
    visit new_child_path
    fill_in 'Name', with: 'alice'
    fill_in 'Birthday', with: Date.current + 1.day
    click_on '登録する'
    assert_text 'Birthdayは今日以前の日付にしてください'
  end
end
