class Admin::ApplicationController < ApplicationController
  before_filter :check_access

  layout "admin"


  def check_access
    if current_user.nil?
      redirect_to root_path
    end
  end
end
