class Zip
  include Mongoid::Document

  field :zip, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :city, type: String
  field :state, type: String

end
