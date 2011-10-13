class User < ActiveRecord::Base
  include ActiveModel::SecurePassword
  has_secure_password

  has_many :user_votes, :dependent => :destroy
  has_many :items, :through => :user_votes, :uniq => true

end
