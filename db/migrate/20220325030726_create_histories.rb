class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|

      t.timestamps
    end
  end
end
