# frozen_string_literal: true

class FamiliesController < ApplicationController
  def index
    @children = current_user.children
    @histories = @children.map(&:histories)
  end
end
