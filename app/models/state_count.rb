class StateCount
  include Mongoid::Document

  field :state, type: String
  field :thumbs_up_count, type: Integer, default: 0
  field :thumbs_down_count, type: Integer, default: 0
  field :neutral_count, type: Integer, default: 0
  field :total_vote_count, type: Integer, default: 0

  embedded_in :national_stat, inverse_of: state_counts
end
