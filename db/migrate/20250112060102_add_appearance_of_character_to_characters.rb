class AddAppearanceOfCharacterToCharacters < ActiveRecord::Migration[7.0]
  def change
    add_column :characters, :appearance, :string
  end
end
