class CreateBattles < ActiveRecord::Migration[6.1]
  def change
    create_table :battles do |t|
      t.integer :character_1_id
      t.integer :character_2_id
      t.integer :winner_id, null: false
      t.text :event, null: false

      t.timestamps
    end

    add_foreign_key :battles, :characters, column: :character_1_id
    add_foreign_key :battles, :characters, column: :character_2_id
    add_foreign_key :battles, :characters, column: :winner_id
  end
end
