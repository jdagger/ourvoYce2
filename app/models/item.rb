class Item < ActiveRecord::Base
  has_many :tag_items, :dependent => :destroy
  has_many :tags, :through => :tag_items, :uniq => true

  has_many :user_votes, :dependent => :destroy
  has_many :users, :through => :user_votes, :uniq => true

  has_many :favorites, :dependent => :destroy, :foreign_key => :item_id
  has_many :users, :through => :favorites, :uniq => true

  def self.get_by_ids(ids)
    Item.select('id, name, description, logo, wikipedia, website, thumbs_up_vote_count, thumbs_down_vote_count, neutral_vote_count').includes(:tag_items => :tag).where(:id => ids)
  end 
end
