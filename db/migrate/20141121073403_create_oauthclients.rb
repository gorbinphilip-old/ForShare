class CreateOauthclients < ActiveRecord::Migration
  def change
    create_table :oauthclients do |t|
      t.string :client_id
      t.string :client_secret
      t.string :provider
      t.string :authorize_url
      t.string :token_url
      t.string :post_url
      t.string :redirect_url

      t.timestamps
    end
  end
end
