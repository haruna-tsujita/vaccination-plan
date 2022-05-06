# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, if: :except_top_page

  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1 || current_user.children.size.zero?
      new_child_path
    elsif current_user.children.size == 1
      child_schedules_path(current_user.children[0])
    elsif current_user.children.size > 1
      families_path
    end
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path # ログアウト後に遷移するpathを設定
  end

  private

  def except_top_page
    true unless controller_name == 'top' && action_name == 'index'
  end
end
