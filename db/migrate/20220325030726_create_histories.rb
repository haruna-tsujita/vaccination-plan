class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.references :vaccination
      t.date :date
      t.boolean :vaccinated
      t.timestamps
    end
  end
end
