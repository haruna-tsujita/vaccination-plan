# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: %i[tos pp]
  before_action :set_active_storage_host

  def after_sign_out_path_for(_resource)
    root_path
  end

  private

  def set_active_storage_host
    return unless %i[local test].include? Rails.application.config.active_storage.service

    ActiveStorage::Current.host = request.base_url
  end
end
