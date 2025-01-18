class ChangeWinnerIdToWinnerNameInBattles < ActiveRecord::Migration[7.0]
  def change
    remove_column :battles, :winner_id, :integer
    add_column :battles, :winner_name, :string
  end
end
