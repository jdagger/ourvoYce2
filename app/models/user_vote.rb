class UserVote
  include Mongoid::Document

  field :user_id, type: String
  field :item_id, type: String
  field :vote, type: Integer
  field :vote_date, type: DateTime

  index [[:user_id, Mongo::ASCENDING], [:item_id, Mongo::ASCENDING]], unique: true

end
