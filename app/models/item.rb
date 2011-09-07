class Item
  include Mongoid::Document

  field :name, type: String
  field :type, type: String
  field :description, type: String
  field :logo, type: String
  field :hot_topic, type: Boolean
  field :wikipedia, type: String
  field :website, type: String
  embeds_many :related_tags
  field :thumbs_up_count, type: Integer, :default => 0
  field :thumbs_down_count, type: Integer, :default => 0
  field :neutral_count, type: Integer, :default => 0
  field :total_vote_count, type: Integer, :default => 0

  #scope :get_by_ids, lambda{ |ids|
  def self.get_by_ids(ids)
    #where(:id.in => ids)
    find(ids)
  end 
end
