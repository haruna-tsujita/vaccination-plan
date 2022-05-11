# frozen_string_literal: true

class HistoriesController < ApplicationController
  before_action :show_page_own_children_only
  before_action :set_child_and_vaccination, only: %i[new edit create update]

  def new
    @history = History.new
    @history.child_id = @child.id
    @history.vaccination_id = @vaccination.id
  end

  def index
    @child = Child.find(params[:child_id])
    @vaccinations = Vaccination.all.order(:id)
  end

  def edit
    @history = History.find(params[:id])
    @history.child_id = @child.id
    @history.vaccination_id = @vaccination.id
  end

  def create
    @history = History.new
    @history.child_id = @child.id
    @history.vaccination_id = @vaccination.id

    respond_to do |format|
      if @history.update(history_params)
        History.automatically_vaccinated(@vaccination.id, @child.id)
        format.html { redirect_to child_histories_url, notice: '接種日時が保存されました' }
        format.json { render :show, status: :ok, location: @history }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @history = History.find(params[:id])
    @history.child_id = @child.id
    @history.vaccination_id = @vaccination.id

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

  def set_child_and_vaccination
    @child = Child.find(params[:child_id])
    @vaccination = vaccination_params
  end

  def show_page_own_children_only
    return if current_user == Child.find(params[:child_id]).user

    redirect_to new_child_path
  end

  def vaccination_params
    if params[:vaccination_id]
      Vaccination.find(params[:vaccination_id])
    else
      history.vaccination_id
    end
  end
end
