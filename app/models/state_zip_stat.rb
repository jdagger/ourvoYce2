class StateYearStat
  include Mongoid::Document

  field :state, type: String
  field :item_id, type: String

end
