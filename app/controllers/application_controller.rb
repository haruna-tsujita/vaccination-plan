# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_active_storage_host

  def after_sign_out_path_for(_resource)
    new_user_session_path # ログアウト後に遷移するpathを設定
  end

  private

  def set_active_storage_host
    return unless %i[local test].include? Rails.application.config.active_storage.service

    ActiveStorage::Current.host = request.base_url
  end
end
