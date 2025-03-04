class AddDecriptionFromUserToCharacters < ActiveRecord::Migration[7.0]
  def change
    add_column :characters, :description_from_user, :text
  end
end
