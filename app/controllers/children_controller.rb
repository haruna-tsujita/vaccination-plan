# frozen_string_literal: true

class ChildrenController < ApplicationController
  before_action :set_child, only: %i[edit update]

  def new
    @child = current_user.children.new
  end

  def edit; end

  def create
    @child = current_user.children.new(child_params)

    if @child.save
      redirect_to child_histories_path(@child), notice: '家族が増えました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @child.update(child_params)
      redirect_to child_histories_path(@child), notice: 'お子さんの情報を編集しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_child
    @child = current_user.children.find(params[:id])
  end

  def child_params
    params.require(:child).permit(:name, :birthday, :avatar)
  end
end
