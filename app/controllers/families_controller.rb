# frozen_string_literal: true

class FamiliesController < ApplicationController
  def index
    @children = current_user.children
    @vaccinations = Vaccination.all.order(:id)
  end
end
