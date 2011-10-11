class StateYearStat
  include Mongoid::Document

  field :state, type: String
  field :item_id, type: String
  key :item_id, :state

  index [[:item_id, Mongo::ASCENDING], [:state, Mongo::ASCENDING]], unique: true

end
