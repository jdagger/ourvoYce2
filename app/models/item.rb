class Item < ActiveRecord::Base
  include VoteCounter

  has_many :tag_items, :dependent => :destroy
  has_many :tags, :through => :tag_items, :uniq => true

  has_many :user_votes, :dependent => :destroy
  has_many :users, :through => :user_votes, :uniq => true

  has_many :favorites, :dependent => :destroy, :foreign_key => :item_id
  has_many :users, :through => :favorites, :uniq => true

  #These attributes are dynamically populated in load_items and used to render the item
  attr_accessor :favorite, :related_tags, :user_vote

  #Thinking Sphinx index
  define_index do
    indexes name, :sortable => true
  end

  class << self
    def get_by_ids(ids)
      #IMPORTANT! Include favorite, user_vote and related_tags in select list so Rails will serialize when converting to json
      Item.select("id, name, false as favorite, '' as related_tags, null as user_vote, description, logo, wikipedia, website, thumbs_up_vote_count, thumbs_down_vote_count, neutral_vote_count").includes(:tag_items => :tag).where(:id => ids)
    end 

    def record_vote(item_id, previous_vote, new_vote)
      return nil unless [-1, 0, 1].include?(new_vote)
      return nil unless [nil, -1, 0, 1].include?(previous_vote)

      return true if previous_vote == new_vote

      item = Item.where(:id => item_id).first
      return nil if item.nil?

      item.update_vote_counts(previous_vote, new_vote)

      item.save
    end

    def lookup_by_name(name)
      search(name, :star => true, :order => "@relevance DESC").map{ |x| {name: x.name, id: x.id } }
    end
  end

end
