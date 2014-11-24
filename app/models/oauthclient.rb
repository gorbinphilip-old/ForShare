class Oauthclient < ActiveRecord::Base
  has_many :auths, dependent: :destroy
end
