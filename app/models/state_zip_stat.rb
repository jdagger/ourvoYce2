class StateZipStat
  include Mongoid::Document

  field :state, type: String
  field :item_id, type: String

  index [[:item_id, Mongo::ASCENDING], [:state, Mongo::ASCENDING]], unique: true
end
