class Item
  include Mongoid::Document

  field :name, String
  field :type, String
  field :description, String
  field :logo, String
  field :hot_topic, Boolean
  field :wikipedia, String
  field :website, String
  embeds_many :related_tags
  field :thumbs_up_count, Integer, :default => 0
  field :thumbs_down_count, Integer, :default => 0
  field :neutral_count, Integer, :default => 0
  field :total_vote_count, Integer, :default => 0

  class << self
    def get_by_ids(ids)
      Item.where('_id' => ids)
    end
  end

end
