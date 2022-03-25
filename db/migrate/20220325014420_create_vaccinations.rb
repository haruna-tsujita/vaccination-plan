class CreateVaccinations < ActiveRecord::Migration[6.1]
  def change
    create_table :vaccinations do |t|
      t.string :name, null: false
      t.string :period
      t.string :key, null: false
      t.timestamps
    end
    add_index :vaccinations, [:key], unique: true
  end
end
