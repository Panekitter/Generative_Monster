class AddImageToCharacters < ActiveRecord::Migration[7.0]
  def change
    add_column :characters, :image, :string
  end
end
