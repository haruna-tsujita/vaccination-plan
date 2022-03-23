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
end
