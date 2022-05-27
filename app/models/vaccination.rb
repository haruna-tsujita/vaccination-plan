# frozen_string_literal: true

class Vaccination < ApplicationRecord
  has_many :history, dependent: :destroy

  def self.regular?(vaccination_name)
    key = Vaccination.find_by(name: vaccination_name).key
    JpVaccination.find(key).regular
  end
end
