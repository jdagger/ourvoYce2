class ApplicationController < ActionController::Base
  protect_from_forgery
  
  append_before_filter :redirect_to_edit_user_if_not_valid_user

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || hot_topics_path
  end

  def redirect_to_edit_user_if_not_valid_user #allows users to be created via omniauth and logged in via omniauth, but forces them to complete required info before using site
    if current_user && !current_user.valid?
      flash.notice = 'Please complete your account information before continuing.'
      redirect_to edit_user_registration_path unless params['controller'] == "devise/registrations" && params['action'] == "edit" #would prefer skip_before_filter here but no easy access to devise controller
    end
  end
end
