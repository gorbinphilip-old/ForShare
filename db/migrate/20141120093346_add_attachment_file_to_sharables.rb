class AddAttachmentFileToSharables < ActiveRecord::Migration
  def self.up
    change_table :sharables do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :sharables, :file
  end
end
