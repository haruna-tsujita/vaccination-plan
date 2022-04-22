class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.references :vaccination, foreign_key: true, index: false, null: false
      t.belongs_to :child, foreign_key: true, index: false, null: false
      t.date :date
      t.boolean :vaccinated
      t.timestamps
    end
    add_index :histories, [:child_id, :vaccination_id], unique: true
  end
end
