class AddWinnerUserIdToBattles < ActiveRecord::Migration[7.0]
  def change
    add_column :battles, :winner_user_id, :integer
    add_foreign_key :battles, :users, column: :winner_user_id, on_delete: :nullify
  end
end
