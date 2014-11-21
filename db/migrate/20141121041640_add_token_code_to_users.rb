class AddTokenCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :code, :string
    add_column :users, :token, :string
  end
end
