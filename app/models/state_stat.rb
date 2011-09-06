class StateStat
  include Mongoid::Document

  field :state, type: String

  embeds_many :birth_year_vote_counts
  embeds_many :zip_vote_counts

end
