class CreateSharables < ActiveRecord::Migration
  def change
    create_table :sharables do |t|
      t.string :name

      t.timestamps
    end
  end
end
