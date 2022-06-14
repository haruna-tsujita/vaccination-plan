class AddUserIdNotNullChildren < ActiveRecord::Migration[6.1]
  def change
    change_column_null :children, :user_id, false
  end
end
