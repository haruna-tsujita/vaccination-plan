# frozen_string_literal: true

class SchedulesController < ApplicationController
  def index
    @user = current_user
    @child = Child.find(params[:child_id])
    @histories = History.where(child_id: @child.id).order(vaccination_id: :asc)
  end
end
