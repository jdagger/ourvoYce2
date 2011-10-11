class NationalYearStat
  include Mongoid::Document

  field :item_id, type: String
  field :birth_year, type: Integer
  key :item_id, :birth_year
  embeds_one :vote

  index [[:item_id, Mongo::ASCENDING], [:birth_year, Mongo::ASCENDING]], unique: true
  index [['_id', Mongo::ASCENDING], [:item_id, Mongo::ASCENDING], [:birth_year, Mongo::ASCENDING]], unique: true
end
