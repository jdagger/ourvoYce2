class DefaultsController < ApplicationController
  #include Items::LoadItems

  def index
    @tags = Tag.all
  end

end
