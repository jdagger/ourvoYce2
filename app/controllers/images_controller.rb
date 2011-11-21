class ImagesController < ApplicationController
  def not_found
    #TODO Record when an image is not found
    #render :layout => false
    send_file("#{Rails.root}/app/assets/images/site/not_found.png", :disposition => 'inline') # => 'not_found.png', :type => 'image/png')
  end
end
