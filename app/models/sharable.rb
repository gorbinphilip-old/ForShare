class Sharable < ActiveRecord::Base

  has_attached_file :file
  validates_attachment :file, :presence => true,
             :size => { :in => 0..10000.kilobytes }
  belongs_to :user

end
