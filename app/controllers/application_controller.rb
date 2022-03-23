# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, if: :except_top_page

  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1
      new_child_path
    else
      children_path
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
