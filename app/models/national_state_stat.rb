class NationalStateStat
  include Mongoid::Document

  field :item_id, type: String
  field :state, type: String
  key :item_id, :state
  embeds_one :vote

  index [[:item_id, Mongo::ASCENDING], [:state, Mongo::ASCENDING]], unique: true
  index [['_id', Mongo::ASCENDING], [:item_id, Mongo::ASCENDING], [:state, Mongo::ASCENDING]], unique: true
end
