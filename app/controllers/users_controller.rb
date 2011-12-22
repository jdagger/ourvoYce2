class UsersController < ApplicationController
  before_filter :authenticate_user!

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      flash[:success] = 'Successfully updated settings'
    end
    render :edit
  end
end
