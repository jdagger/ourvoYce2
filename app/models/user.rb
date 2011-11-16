class User < ActiveRecord::Base
  include ActiveModel::SecurePassword
  has_secure_password

  validates :email, :presence => true, :uniqueness => true, :email => true
  validates :password, :presence => true, :length => {:minimum => 6, :maximum => 13}, :on => :create #TODO - Check for updating password, as well
  validates :country, :presence => true, :inclusion => {:in => Country::COUNTRIES }
  validates :zip, :presence => true, :length => {:minimum => 4, :maximum => 5}, :us_zip => true
  validates :state, :presence => true, :state => true
  validates :birth_year, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => lambda {|x| 100.years.ago.year}, :less_than_or_equal_to => lambda {|x| 13.years.ago.year} }


  has_many :user_votes, :dependent => :destroy
  has_many :items, :through => :user_votes, :uniq => true

  has_many :favorites, :dependent => :destroy, :foreign_key => :user_id
  has_many :items, :through => :favorites, :uniq => true

end
