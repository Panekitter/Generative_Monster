class AddUsedSkillsToBattles < ActiveRecord::Migration[7.0]
  def change
    add_column :battles, :user_skill_name, :string
    add_column :battles, :opponent_skill_name, :string
    add_column :battles, :user_skill_description, :string
    add_column :battles, :opponent_skill_description, :string
  end
end
