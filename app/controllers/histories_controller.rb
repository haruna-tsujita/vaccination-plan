# frozen_string_literal: true

class HistoriesController < ApplicationController
  before_action :set_child, only: %i[new edit create update index destroy]
  before_action :set_history, only: %i[edit update destroy]
  before_action :set_vaccination, only: %i[new edit create update]

  def new
    date = Schedule.next_plan(@vaccination, @child)
    @history = @child.histories.new(date: [Date, String].include?(date.class) ? date : date.first)
    @history.vaccination_id = @vaccination.id
  end

  def index
    @vaccinations = Vaccination.all.order(:id)
    @histories = @child.histories
  end

  def edit; end

  def create
    @history = @child.histories.new(history_params)
    @history.vaccination_id = @vaccination.id

    if @history.save
      History.automatically_vaccinated(@vaccination, @child)
      redirect_to child_histories_url, notice: '接種日時が保存されました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update
    if @history.update(history_params)
      History.automatically_vaccinated(@history.vaccination, @history.child)
      redirect_to child_histories_url, notice: '接種日時が保存されました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to child_histories_url, notice: 'ワクチンの接種情報を削除しました' if @history.destroy!
  end

  private

  def history_params
    params.require(:history).permit(:date, :vaccinated, :vaccination_id)
  end

  def set_child
    @child = current_user.children.find(params[:child_id])
  end

  def set_history
    @history = @child.histories.find(params[:id])
  end

  def set_vaccination
    @vaccination = Vaccination.find(params[:vaccination_id])
  end
end
