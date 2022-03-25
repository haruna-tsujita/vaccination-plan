class History < ApplicationRecord
  belongs_to :child
  belongs_to :vaccination
end
