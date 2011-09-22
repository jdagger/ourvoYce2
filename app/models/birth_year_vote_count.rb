class BirthYearVoteCount
  include Mongoid::Document

  field :birth_year, type: Integer
  embeds_one :vote

  embedded_in :state_stat

end
