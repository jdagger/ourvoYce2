class NationalStateStat
  include Mongoid::Document

  field :item_id, type: String
  field :state, type: String
  embeds_one :vote

  index [[:item_id, Mongo::ASCENDING], [:state, Mongo::ASCENDING]], unique: true
end
