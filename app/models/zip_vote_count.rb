class ZipVoteCount
  include Mongoid::Document

  field :zip, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :thumbs_up_count, type: Integer, default: 0
  field :thumbs_down_count, type: Integer, default: 0
  field :neutral_count, type: Integer, default: 0
  field :total_vote_count, type: Integer, default: 0

  embedded_in :state_stat, inverse_of: zip_vote_counts
end
