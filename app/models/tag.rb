class Tag < ActiveRecord::Base
  has_many :tag_items, :dependent => :destroy
  has_many :items, :through => :tag_items, :uniq => true

  scope :popular_tags, select([:friendly_name, :path]).where(:popular => true)
  scope :hot_topics, select([:friendly_name, :path]).where(:hot_topic => true)

  default_scope :order => 'friendly_name asc'

end
