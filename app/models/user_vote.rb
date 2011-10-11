class UserVote
  include Mongoid::Document

  field :user_id, type: String
  field :item_id, type: String
  field :vote, type: Integer, default: nil
  field :vote_date, type: DateTime
  key :user_id, :item_id

  #index [[:user_id, Mongo::ASCENDING], [:item_id, Mongo::ASCENDING]], unique: true
  index [[:item_id, Mongo::ASCENDING], [:user_id, Mongo::ASCENDING]], unique: true

end
