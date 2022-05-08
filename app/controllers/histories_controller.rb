# frozen_string_literal: true

class HistoriesController < ApplicationController
  before_action :show_page_own_children_only

  def index
    @child = Child.find(params[:child_id])
    @histories = History.where(child_id: params[:child_id]).order(vaccination_id: :asc)
  end

  def edit
    @child = Child.find(params[:child_id])
    @history = History.find(params[:id])
    @history.child_id = @child.id
  end

  def show; end

  def update
    @child = Child.find(params[:child_id])
    @history = History.find(params[:id])
    @history.child_id = @child.id

    respond_to do |format|
      if @history.update(history_params)
        History.automatically_vaccinated(@history.vaccination_id, @history.child_id)
        format.html { redirect_to child_histories_url, notice: '接種日時が保存されました' }
        format.json { render :show, status: :ok, location: @history }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def history_params
    params.require(:history).permit(:date, :vaccinated, :vaccination_id, :id)
  end

  def show_page_own_children_only
    return if current_user == Child.find(params[:child_id]).user

    redirect_to new_child_path
  end
end
