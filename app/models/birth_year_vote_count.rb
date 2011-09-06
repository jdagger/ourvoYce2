class BirthYearVoteCount
  include Mongoid::Document

  field :birth_year, type: Integer
  field :thumbs_up_count, type: Integer, default: 0
  field :thumbs_down_count, type: Integer, default: 0
  field :neutral_count, type: Integer, default: 0
  field :total_vote_count, type: Integer, default: 0

  embedded_in :national_stat, inverse_of: birth_year_vote_counts
  embedded_in :state_stat, inverse_of: birth_year_vote_counts
end
