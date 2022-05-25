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

  setup do
    @raise_server_errors = Capybara.raise_server_errors
  end

  teardown do
    Capybara.raise_server_errors = @raise_server_errors
  end

  test 'create history when user logged in' do
    setup_alice
    alice_child = children(:carol)
    vaccination_key = 'BCG_1'
    visit new_child_history_path(alice_child.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.parse('2022-02-01')
    click_on '登録する'
    assert_text '接種日時が保存されました'
  end

  test 'not create history when user logged in' do
    setup_alice
    alice_child = children(:carol)
    vaccination_key = 'BCG_1'
    visit new_child_history_path(alice_child.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    'ログインもしくはアカウント登録してください。'
  end

  test 'not create any child other than their own' do
    Capybara.raise_server_errors = false
    setup_alice
    bob_child = children(:dave)
    vaccination_key = 'MR_1'
    visit new_child_history_path(bob_child.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    assert_text 'ActiveRecord::RecordNotFound'
  end

  test 'edit history when user logged in' do
    setup_alice
    alice_child = children(:eve)
    vaccination_key = 'rotavirus_1'
    visit edit_child_history_path(alice_child.id, histories(:eve_history_rotavirus_first).id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.parse('2021-02-01')
    click_on '登録する'
    assert_text '接種日時が保存されました'
  end

  test 'not edit history before user logged in' do
    setup_alice
    logout
    vaccination_key = 'rotavirus_1'
    visit edit_child_history_path(children(:eve).id, histories(:eve_history_rotavirus_first).id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    assert_text 'ログインもしくはアカウント登録してください。'
  end

  test 'not edit any child other than their own' do
    Capybara.raise_server_errors = false
    setup_bob
    alice_child = children(:eve)
    vaccination_key = 'rotavirus_1'
    visit edit_child_history_path(alice_child.id, histories(:eve_history_rotavirus_first).id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    assert_text 'ActiveRecord::RecordNotFound'
  end

  test 'validation history before today' do
    setup_alice
    carol = children(:carol)
    vaccination_key = 'rotavirus_3'
    visit new_child_history_path(carol.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.current
    click_on '登録する'
    assert_text '接種日時が保存されました'
  end

  test 'validation not update history after tommorow' do
    setup_alice
    carol = children(:carol)
    vaccination_key = 'rotavirus_3'
    visit new_child_history_path(carol.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.current + 1.day
    click_on '登録する'
    assert_text '接種日時は今日より前の日付にしてください'
  end

  test 'validation bigger than before history' do
    setup_alice
    eve = children(:eve)
    histories(:eve_history_rotavirus_first).update(date: Date.current - 1.month)

    vaccination_key = 'rotavirus_3'
    visit new_child_history_path(eve.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.current - 1.month - 1.day
    click_on '登録する'
    assert_text '接種日時が前回の期より前の日付になっています'
  end

  test 'validation bigger than before before history' do
    setup_alice
    eve = children(:eve)
    histories(:eve_history_rotavirus_first).update(date: Date.current - 1.month)

    vaccination_key = 'rotavirus_3'
    visit new_child_history_path(eve.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.current - 2.months - 1.day
    click_on '登録する'
    assert_text '接種日時が前回の期より前の日付になっています'
  end

  test 'validation not update bigger than before history' do
    setup_alice
    eve = children(:eve)
    histories(:eve_history_rotavirus_first).update(date: Date.current - 1.month)

    vaccination_key = 'rotavirus_3'
    visit edit_child_history_path(eve.id, histories(:eve_history_rotavirus_third).id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.current - 1.month + 1.day
    click_on '登録する'
    assert_text '接種日時が保存されました'
  end

  test 'validation smaller than before history' do
    setup_alice
    eve = children(:eve)
    histories(:eve_history_rotavirus_first).update(date: Date.current - 1.month)

    vaccination_key = 'rotavirus_2'
    visit new_child_history_path(eve.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.current - 1.month + 1.day
    click_on '登録する'
    assert_text '接種日時が次回の期より後の日付になっています'
  end

  test 'validation smaller than before before history' do
    setup_alice
    eve = children(:eve)
    histories(:eve_history_rotavirus_third).update(date: Date.current - 1.month)

    vaccination_key = 'rotavirus_1'
    visit new_child_history_path(eve.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.current - 1.month + 1.day
    click_on '登録する'
    assert_text '接種日時が次回の期より後の日付になっています'
  end

  test 'validation update smaller than before history' do
    setup_alice
    eve = children(:eve)
    histories(:eve_history_rotavirus_third).update(date: Date.current - 1.month)

    vaccination_key = 'rotavirus_2'
    visit edit_child_history_path(eve.id, histories(:eve_history_rotavirus_second), vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.current - 1.month - 1.day
    click_on '登録する'
    assert_text '接種日時が保存されました'
  end

  test 'validation history unique vaccination' do
    setup_alice
    eve = children(:eve)
    histories(:eve_history_rotavirus_third).update(date: Date.current - 1.month)

    vaccination_key = 'rotavirus_2'
    visit new_child_history_path(eve.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    fill_in '接種日', with: Date.current - 1.month - 1.day
    click_on '登録する'
    assert_text 'Vaccinationはすでに存在します'
  end

  test 'validation history not date and vaccinated' do
    setup_alice
    eve = children(:eve)
    histories(:eve_history_rotavirus_third).update(date: Date.current - 1.month)

    vaccination_key = 'rotavirus_3'
    visit new_child_history_path(eve.id, vaccination_id: vaccinations(:"#{vaccination_key}"))
    click_on '登録する'
    assert_text '接種日時が入力されていません'
  end
end
