class CreateSkills < ActiveRecord::Migration[6.1]
  def change
    create_table :skills do |t|
      t.references :character, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
