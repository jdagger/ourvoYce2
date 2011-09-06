class RelatedTag
  include MongoMapper::EmbeddedDocument

  key :key_id, ObjectId
  key :friendly_name, String
  key :path, String
  embedd_in :item, inverse_of: related_tags
end
