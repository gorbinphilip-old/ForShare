class AddUserIdToSharables < ActiveRecord::Migration
  def change
    add_column :sharables, :user_id, :integer
  end
end
