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

  def setup_ivan
    Warden.test_mode!
    @ivan = users(:ivan)
    login_as(@ivan, scope: :user)
  end

  test 'redirect to histories_path when login and user has one child' do
    setup_ellen
    visit '/'
    moon_age = Child.calc_moon_age(children(:issac).birthday, Date.current)
    assert_text "issac #{moon_age}\n2018年10月29日生まれ"
    assert_text 'ワクチンの記録'
    assert_no_text 'ログイン'
  end

  test 'redirect to new_child_path when login and user has no child' do
    setup_ivan
    visit '/'
    assert_text '子どもの登録'
    assert_no_text 'ログイン'
  end

  test 'redirect to families_path when login and user has many child' do
    setup_bob
    visit '/'
    assert_text '予定日を過ぎました'
    assert_no_text 'ログイン'
  end
end
