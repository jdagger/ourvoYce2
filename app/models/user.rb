class User
  include ActiveModel::SecurePassword
  include Mongoid::Document

  has_secure_password

  field :email, type: String
  field :password_digest, type: String
  field :country, type: String
  field :zip, type: String
  field :state, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :birth_year, type: Integer
  field :member_since, type: Date
  field :vote_count, type: Integer
  field :confirmed, type: Boolean
  field :favorites, type: Array
  field :favorites_count, type: Integer

end
