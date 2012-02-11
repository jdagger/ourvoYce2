class Tag < ActiveRecord::Base
  has_many :tag_items, :dependent => :destroy
  has_many :items, :through => :tag_items, :uniq => true

  scope :popular_tags, select([:friendly_name, :path]).where(:popular => true)
  scope :hot_topics, select([:friendly_name, :path]).where(:hot_topic => true)

  scope :by_friendly_name, lambda { |friendly_name| where("lower(friendly_name) = ?", friendly_name.downcase) }

  validates_uniqueness_of :path
  validates_presence_of :path, :friendly_name


  #Thinking Sphinx Index
  define_index do
    indexes friendly_name, :sortable => true
  end

  class << self
    def do_search(value)
      search(value, :star => true, :order => "@relevance DESC").map{ |x| {friendly_name: x.friendly_name, path: x.path } }
    end

    def lookup_by_name(name)
      search(name, :star => true, :order => "@relevance DESC").map{ |x| {name: x.friendly_name, id: x.id } }
    end
  end
end
