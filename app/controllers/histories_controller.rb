# frozen_string_literal: true

class HistoriesController < ApplicationController
  def new
    @child = Child.find(params[:child_id])
    @history = History.new
  end

  def index
    @histories = History.where(child_id: params[:child_id])
  end

  def edit
    @child = Child.find(params[:child_id])
    @history = History.find(params[:id])
  end

  def show; end

  def create
    @child = Child.find(params[:child_id])
    @history = History.new(history_params)
    @history.child_id = @child.id

    respond_to do |format|
      if @history.save
        format.html { redirect_to child_histories_url, notice: 'History was successfully created.' }
        format.json { render :show, status: :created, location: @history }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @child = Child.find(params[:child_id])
    @history = History.find(params[:id])

    respond_to do |format|
      if @history.update(history_params)
        format.html { redirect_to child_histories_url, notice: "History was successfully updated." }
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
end
