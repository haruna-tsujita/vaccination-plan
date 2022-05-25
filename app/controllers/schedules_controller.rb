# frozen_string_literal: true

class SchedulesController < ApplicationController
  def index
    @child = current_user.children.find(params[:child_id])
    vaccinations = Vaccination.all.order(:id)
    @schedules = Schedule.future_plans(vaccinations, @child)
  end
end
