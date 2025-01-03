class ChangeWinnerIdToAllowNullInBattles < ActiveRecord::Migration[7.0]
  def change
    change_column_null :battles, :winner_id, true
  end
end
