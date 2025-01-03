class ModifyWinnerForeignKeyOnBattles < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :battles, column: :winner_id
    add_foreign_key :battles, :characters, column: :winner_id, on_delete: :nullify
  end
end
