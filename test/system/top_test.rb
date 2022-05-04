# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class Toptest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  def setup_alice
    Warden.test_mode!
    @alice = users(:alice)
    login_as(@alice, scope: :user)
  end

  def setup_ellen
    Warden.test_mode!
    @ellen = users(:ellen)
    login_as(@ellen, scope: :user)
  end

  def setup_bob
    Warden.test_mode!
    @bob = users(:bob)
    login_as(@bob, scope: :user)
  end

  test 'redirect to new_child_path when login and user has one child' do
    setup_alice
    visit '/'
    assert_text "carol\n0才 3ヶ月\n2022年01月03日生まれ"
    assert_no_text 'ログイン'
  end

  test 'redirect to new_child_path when login and user has no child' do
    setup_ellen
    visit '/'
    assert_text '子どもの登録'
    assert_no_text 'ログイン'
  end

  test 'redirect to new_child_path when login and user has many child' do
    setup_bob
    visit '/'
    assert_text '接種できるリスト'
    assert_no_text 'ログイン'
  end
end
