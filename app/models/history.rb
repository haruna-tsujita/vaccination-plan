# frozen_string_literal: true

class History < ApplicationRecord
  belongs_to :child
  belongs_to :vaccination
end
