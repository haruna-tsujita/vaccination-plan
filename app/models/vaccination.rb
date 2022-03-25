# frozen_string_literal: true

class Vaccination < ApplicationRecord
  has_one :history, dependent: :nullify
end
