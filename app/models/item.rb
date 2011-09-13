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
  embeds_one :vote

  def self.get_by_ids(ids)
    find(ids)
  end 
end
