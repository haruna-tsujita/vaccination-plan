# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class Historiestest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:alice)
    login_as(@user, scope: :user)
  end

  test 'edit history when user logged in' do
    setup
    alice_child = children(:carol)
    visit edit_child_history_path(alice_child.id, histories(:carol_history_hib_first).id)
    fill_in 'ワクチンをうった日付', with: Date.parse('2022-02-01')
    click_on '更新する'
    visit child_histories_path(child_id: alice_child.id)
    assert_text '2022-02-01'
    assert_text '❶'
  end

  test 'not edit history before user logged in' do
    setup
    logout
    visit edit_child_history_path(children(:carol).id, histories(:carol_history_hib_first).id)
    assert_text 'ログインもしくはアカウント登録してください。'
  end

  test 'not edit any child other than their own' do
    setup
    bob_child = children(:dave)
    visit edit_child_history_path(bob_child.id, histories(:dave_history_hib_first).id)
    assert_text 'Children#index'
  end
end
