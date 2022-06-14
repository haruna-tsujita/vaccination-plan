class ChangeVaccinatedDefaultFalseHistories < ActiveRecord::Migration[6.1]
  def change
    change_column_default :histories, :vaccinated, from: nil, to: false
  end
end
