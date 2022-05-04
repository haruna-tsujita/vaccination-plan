# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class Userstest < ApplicationSystemTestCase
  test 'send_confirmation_mail' do
    visit new_user_registration_path
    fill_in 'user[email]', with: 'test@example.com'
    fill_in 'user[password]', with: 'testtest'
    fill_in 'user[password_confirmation]', with: 'testtest'
    click_on '登録する'
    assert_text '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
  end
end
