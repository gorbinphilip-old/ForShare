class CreateAuths < ActiveRecord::Migration
  def change
    create_table :auths do |t|
      t.string :token
      t.string :code
      t.integer :user_id
      t.integer :oauthclient_id
      t.timestamps
    end
  end
end
