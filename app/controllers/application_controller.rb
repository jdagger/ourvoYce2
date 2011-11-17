class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  #def current_user
  #  if session[:user_id]
  #    begin
  #      @current_user ||= User.find(session[:user_id])
  #    rescue
  #      session[:user_id] = nil
  #    end

  #  end
  #end


  #def logged_in?
  #  ! current_user.nil?
  #end

  #helper_method :current_user
  #helper_method :logged_in?

end
