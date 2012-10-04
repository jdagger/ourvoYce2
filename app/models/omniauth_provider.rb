class OmniauthProvider < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :provider, :presence => true
  validates :uid, :presence => true
  
  belongs_to :user

  attr_accessible :provider, :uid, :user_id, :confirmed

end
