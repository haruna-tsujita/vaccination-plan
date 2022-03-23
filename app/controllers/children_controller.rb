# frozen_string_literal: true

class ChildrenController < ApplicationController
  def index; end

  def show; end

  def new
    @child = Child.new
  end

  def create
    @child = Child.new(child_params)

    respond_to do |format|
      if @child.save
        format.html { redirect_to child_url(@child), notice: 'Child was successfully created.' }
        format.json { render :show, status: :created, location: @child }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  private

  # Only allow a list of trusted parameters through.
  def child_params
    params.require(:child).permit(:name, :birthday)
  end
end
