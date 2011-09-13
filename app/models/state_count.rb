class StateCount
  include Mongoid::Document

  field :state, type: String
  embeds_one :vote

  embedded_in :national_stat, inverse_of: state_counts
end
