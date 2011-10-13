class Item < ActiveRecord::Base
  has_many :keyword_items, :dependent => :destroy
  has_many :keywords, :through => :keyword_items, :uniq => true

  has_many :user_votes, :dependent => :destroy
  has_many :users, :through => :user_votes, :uniq => true

  def self.get_by_ids(ids)
    Item.select('id, name, description, logo, wikipedia, website, thumbs_up_vote_count, thumbs_down_vote_count, neutral_vote_count').includes(:keyword_items => :keyword).where(:id => ids)
  end 
end
