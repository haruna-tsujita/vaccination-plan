# frozen_string_literal: true

class HistoriesController < ApplicationController
  def new
    @child = Child.find(params[:child_id])
    @history = History.new
  end

  def index; end

  def edit; end

  def show; end

  def create
    @child = Child.find(params[:child_id])
    @history = History.new(history_params)
    @history.child_id = @child.id

    respond_to do |format|
      if @history.save
        format.html { redirect_to history_url(@history), notice: 'History was successfully created.' }
        format.json { render :show, status: :created, location: @history }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def history_params
    params.require(:history).permit(:date, :vaccinated)
  end
end
