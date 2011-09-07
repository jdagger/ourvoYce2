class Keyword
  include Mongoid::Document

  field :friendly_name, type: String
  field :path, type: String
  field :item_ids, type: Array

  def self.keyword_by_path(path)
    where(path: path).only([:friendly_name, :item_ids]).first
  end 

  scope :keyword_list, all.only([:friendly_name, :path])

end
