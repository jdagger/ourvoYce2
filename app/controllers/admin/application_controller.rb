class Admin::ApplicationController < ApplicationController
  before_filter :check_access

  layout "admin"

  def check_access
    if current_user.nil? || (current_user.email != 'jon@ourvoyce.com' && current_user.email != 'ryan@ourvoyce.com')
      #redirect_to root_path
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
