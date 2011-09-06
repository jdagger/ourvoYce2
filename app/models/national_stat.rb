class NationalStat
  include Mongoid::Document

  field :item_id, type: String
  embeds_many :birth_year_vote_counts
  embeds_many :state_counts
end
