class NationalYearStat
  include Mongoid::Document

  field :item_id, type: String
  field :birth_year, type: Integer
  embeds_one :vote

  index [[:item_id, Mongo::ASCENDING], [:birth_year, Mongo::ASCENDING]], unique: true
end
