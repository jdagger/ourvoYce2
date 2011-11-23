class ImagesController < ApplicationController
  def not_found
    #TODO Record when an image is not found
    send_file("#{Rails.root}/app/assets/images/site/not_found.png", :disposition => 'inline', :type => 'image/png')
  end
end
