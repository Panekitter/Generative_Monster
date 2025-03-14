class ChangeForeignKeysOnBattles < ActiveRecord::Migration[7.0]
  def change
    # 既存の外部キーを削除
    remove_foreign_key :battles, column: :character_1_id if foreign_key_exists?(:battles, column: :character_1_id)
    remove_foreign_key :battles, column: :character_2_id if foreign_key_exists?(:battles, column: :character_2_id)
    
    # 外部キーをon_delete: :nullifyで再追加
    add_foreign_key :battles, :characters, column: :character_1_id, on_delete: :nullify
    add_foreign_key :battles, :characters, column: :character_2_id, on_delete: :nullify
  end
end
