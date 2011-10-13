class KeywordItem < ActiveRecord::Base
  belongs_to :keyword
  belongs_to :item
end
