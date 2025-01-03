class CreateCharacters < ActiveRecord::Migration[6.1]
  def change
    create_table :characters do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description, null: false
      t.integer :hp, null: false
      t.integer :agility, null: false
      t.integer :strength, null: false
      t.integer :intelligence, null: false

      t.timestamps
    end
  end
end
