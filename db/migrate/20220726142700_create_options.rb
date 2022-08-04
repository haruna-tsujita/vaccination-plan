class CreateOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :options do |t|
      t.boolean :mumps, null: false, default: true
      t.boolean :rotateq, null: false, default: true
      t.belongs_to :child, foreign_key: true, null: false, unique: true
      t.timestamps
    end
  end
end
