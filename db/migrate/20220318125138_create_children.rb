class CreateChildren < ActiveRecord::Migration[6.1]
  def change
    create_table :children do |t|
      t.string :name, null:false
      t.date :birthday, null:false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
