class RelatedTag
  include Mongoid::Document

  field :path, type: String
  field :friendly_name, type: String
  embedded_in :item
end
