# frozen_string_literal: true

class TopController < ApplicationController
  def index
    if current_user.children.size == 0
      redirect_to new_child_path
    elsif current_user.children.size == 1
      redirect_to child_histories_path(current_user.children[0])
    elsif current_user.children.size > 1
      redirect_to families_path
    end
  end
end
