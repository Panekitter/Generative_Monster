class CreateCharacterCreationLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :character_creation_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :created_at, null: false
    end
  end
end
