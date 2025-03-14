class AddCharacterNameToBattles < ActiveRecord::Migration[7.0]
  def change
    add_column :battles, :character_1_name, :string
    add_column :battles, :character_2_name, :string
  end
end
