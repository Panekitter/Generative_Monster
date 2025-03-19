class AddNoLimitToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :no_limit, :boolean, default: false, null: false
  end
end
