class AddBattleAndWinCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :battle_count, :integer, default: 0, null: false
    add_column :users, :win_count, :integer, default: 0, null: false
  end
end
