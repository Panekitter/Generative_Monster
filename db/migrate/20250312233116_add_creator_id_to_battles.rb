class AddCreatorIdToBattles < ActiveRecord::Migration[7.0]
  def change
    add_column :battles, :user_id, :integer
    add_foreign_key :battles, :users, on_delete: :cascade
    add_index :battles, :user_id
  end
end
