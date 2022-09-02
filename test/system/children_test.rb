# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class Childrentest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:alice)
    login_as(@user, scope: :user)
  end

  test 'after_login_visit_children_index' do
    setup
    visit new_child_path
    assert_text '子どもの登録'
  end

  test 'not_login_do_not_visit_children_index' do
    setup
    logout
    visit new_child_path
    assert_text 'ログインもしくはアカウント登録してください。'
  end

  test 'create_new_child' do
    setup
    visit new_child_path
    fill_in '名前', with: 'hanako'
    fill_in '生年月日', with: Date.parse('2022-03-01')
    click_on '保存'
    assert_text '家族が増えました'
    assert_text 'hanako'
    assert_text '2022年03月01日'
  end

  test 'update_new_child' do
    setup
    visit "/children/#{children(:carol).id}/edit"
    fill_in '名前', with: '桃子'
    fill_in '生年月日', with: Date.parse('2022-03-03')
    click_on '保存'
    assert_text 'お子さんの情報を編集しました'
    assert_text '桃子'
    assert_text '2022年03月03日'
  end

    test 'destroy_child' do
    setup
    visit "/children/#{children(:carol).id}/edit"
    accept_confirm do
      click_link "削除"
    end
    assert_text 'お子さんの情報を削除しました'
  end

  test 'name_and_birthday_is_valid' do
    setup
    visit new_child_path
    fill_in '名前', with: nil
    fill_in '生年月日', with: nil
    click_on '保存'
    assert_text '名前を入力してください'
    assert_text '生年月日を入力してください'
  end

  test 'birthday_is_not_after_today' do
    setup
    visit new_child_path
    fill_in '名前', with: 'alice'
    fill_in '生年月日', with: Date.current + 1.day
    click_on '保存'
    assert_text '生年月日は今日以前の日付にしてください'
  end
end
