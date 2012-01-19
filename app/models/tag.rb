class Tag < ActiveRecord::Base
  has_many :tag_items, :dependent => :destroy
  has_many :items, :through => :tag_items, :uniq => true

  scope :popular_tags, select([:friendly_name, :path]).where(:popular => true)
  scope :hot_topics, select([:friendly_name, :path]).where(:hot_topic => true)

  scope :by_friendly_name, lambda { |friendly_name| where("lower(friendly_name) = ?", friendly_name.downcase) }

  default_scope :order => 'friendly_name asc'


  #Thinking Sphinx Index
  define_index do
    # fields
    #indexes subject, :sortable => true
    #indexes content
    #indexes author.name, :as => :author, :sortable => true
    indexes friendly_name, :sortable => true

    # attributes
    #has author_id, created_at, updated_at
    #has id
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
