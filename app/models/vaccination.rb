# frozen_string_literal: true

class Vaccination < ApplicationRecord
  has_many :history, dependent: :destroy

  def regular?
    JpVaccination.find(key).regular
  end
end
