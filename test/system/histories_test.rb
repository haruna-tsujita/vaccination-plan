# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class Historiestest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  def setup_alice
    Warden.test_mode!
    @alice = users(:alice)
    login_as(@alice, scope: :user)
  end

  def setup_bob
    Warden.test_mode!
    @bob = users(:bob)
    login_as(@bob, scope: :user)
  end

  test 'edit history when user logged in' do
    setup_alice
    alice_child = children(:carol)
    visit edit_child_history_path(alice_child.id, histories(:carol_history_hib_first).id)
    fill_in '接種した日', with: Date.parse('2022-02-01')
    click_on '登録する'
    assert_text '接種日時が保存されました'
    assert_text '22/02/01'
    assert_text '❶'
  end

  test 'not edit history before user logged in' do
    setup_alice
    logout
    visit edit_child_history_path(children(:carol).id, histories(:carol_history_hib_first).id)
    assert_text 'ログインもしくはアカウント登録してください。'
  end

  test 'not edit any child other than their own' do
    setup_alice
    bob_child = children(:dave)
    visit edit_child_history_path(bob_child.id, histories(:dave_history_hib_first).id)
    assert_text 'Children#index'
  end

  test 'validation history before today' do
    setup_alice
    carol = children(:carol)
    visit edit_child_history_path(carol.id, histories(:carol_history_hib_first).id)
    fill_in '接種した日', with: Date.current
    click_on '登録する'
    assert_text Date.current.strftime('%y/%m/%d')
  end

  test 'validation not update history after tommorow' do
    setup_alice
    carol = children(:carol)
    visit edit_child_history_path(carol.id, histories(:carol_history_hib_first).id)
    fill_in '接種した日', with: Date.current + 1.day
    click_on '登録する'
    assert_text '接種日時は今日より前の日付にしてください'
  end

  test 'validation bigger than before history' do
    setup_alice
    carol = children(:carol)
    histories(:carol_history_rotavirus_second).update(date: Date.current - 1.month)
    visit edit_child_history_path(carol.id, histories(:carol_history_rotavirus_third).id)
    fill_in '接種した日', with: Date.current - 1.month - 1.day
    click_on '登録する'
    assert_text '接種日時が前回の期より前の日付になっています'
  end

  test 'validation not update bigger than before history' do
    setup_alice
    carol = children(:carol)
    histories(:carol_history_rotavirus_second).update(date: Date.current - 1.month)
    visit edit_child_history_path(carol.id, histories(:carol_history_rotavirus_third).id)
    fill_in '接種した日', with: Date.current - 1.month + 1.day
    click_on '登録する'
    assert_text '接種日時が保存されました'
  end

  test 'validation smaller than before history' do
    setup_alice
    carol = children(:carol)
    histories(:carol_history_rotavirus_third).update(date: Date.current - 1.month)
    visit edit_child_history_path(carol.id, histories(:carol_history_rotavirus_second).id)
    fill_in '接種した日', with: Date.current - 1.month + 1.day
    click_on '登録する'
    assert_text '接種日時が次回の期より後の日付になっています'
  end

  test 'validation not update smaller than before history' do
    setup_alice
    carol = children(:carol)
    histories(:carol_history_rotavirus_third).update(date: Date.current - 1.month)
    visit edit_child_history_path(carol.id, histories(:carol_history_rotavirus_second).id)
    fill_in '接種した日', with: Date.current - 1.month - 1.day
    click_on '登録する'
    assert_text '接種日時が保存されました'
  end

  test 'automatically_vaccinated' do
    setup_bob
    dave = children(:dave)
    visit "/children/#{dave.id}/histories/#{History.find_by(child_id: dave.id, vaccination_id: Vaccination.find_by(key: 'hib_2').id).id}/edit"
    assert_text 'ヒブ 第2期'
    fill_in '接種した日', with: Date.current
    click_on '登録する'
    assert_equal true, History.find_by(child_id: dave.id, vaccination_id: Vaccination.find_by(key: 'hib_1').id).vaccinated
    assert_nil History.find_by(child_id: dave.id, vaccination_id: Vaccination.find_by(key: 'hib_3').id).vaccinated
    assert_nil History.find_by(child_id: dave.id, vaccination_id: Vaccination.find_by(key: 'hib_4').id).vaccinated
  end
end
