class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.references :vaccination
      t.belongs_to :child, index: true, foreign_key: true
      t.date :date
      t.boolean :vaccinated
      t.timestamps
    end
  end
end
