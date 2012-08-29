class TagsController < ApplicationController

  def index
    @tags = Tag.order('friendly_name asc')
    @histogram = Tag.to_histogram
  end

end
