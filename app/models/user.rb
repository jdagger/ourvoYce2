class User
  include Mongoid::Document

  field :email, type: String
  field :password, type: String
  field :country, type: String
  field :zip, type: String
  field :year_born, type: String
  field :member_since, type: Date
  field :vote_count, type: Integer
  field :confirmed, type: Boolean
  field :favorites, type: Array
  field :favorites_count, type: Integer
end
