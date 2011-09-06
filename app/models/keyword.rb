class Keyword
  include Mongoid::Document

  field :friendly_name, type: String
  field :path, type: String
  field :item_ids, type: Array

  scope :items_by_path, lambda { |path|
    where(:path => path)
  }
  #scope :items_by_path, lambda { |path| 
    #all(:select => [:item_ids], :conditions => {:path => path})
    #select('item_ids').where(:path => path)
    #find_all_by_path(path)
  #}

  class << self
     # def items_by_path(path)
      #find_by_path(path)
    #end

    def keyword_list
      all(:select => [:friendly_name, :path])
    end
  end

end
