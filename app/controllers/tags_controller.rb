class TagsController < ApplicationController

  def index
    @tags = Tag.order('friendly_name asc')
  end

end
