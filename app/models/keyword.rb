class Keyword < ActiveRecord::Base
  has_many :keyword_items, :dependent => :destroy
  has_many :items, :through => :keyword_items, :uniq => true

  scope :keyword_list, select([:friendly_name, :path])

end
