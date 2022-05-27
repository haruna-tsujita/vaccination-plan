# frozen_string_literal: true

class HistoriesController < ApplicationController
  before_action :set_child, only: %i[new edit create update index]
  before_action :set_vaccination, only: %i[new edit create update]

  def new
    @history = @child.histories.new
    @history.vaccination_id = @vaccination.id
  end

  def index
    @vaccinations = Vaccination.all.order(:id)
  end

  def edit
    @history = @child.histories.find(params[:id])
  end

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
    @history = @child.histories.find(params[:id])

    if @history.update(history_params)
      History.automatically_vaccinated(@history.vaccination, @history.child)
      redirect_to child_histories_url, notice: '接種日時が保存されました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def history_params
    params.require(:history).permit(:date, :vaccinated, :vaccination_id)
  end

  def set_child
    @child = current_user.children.find(params[:child_id])
  end

  def set_vaccination
    @vaccination = Vaccination.find(params[:vaccination_id])
  end
end
