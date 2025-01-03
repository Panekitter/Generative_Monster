class ModifyForeignKeysOnBattles < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :battles, column: :character_1_id
    remove_foreign_key :battles, column: :character_2_id

    add_foreign_key :battles, :characters, column: :character_1_id, on_delete: :nullify
    add_foreign_key :battles, :characters, column: :character_2_id, on_delete: :nullify
  end
end
