class SessionsController < ApplicationController
  def login
    user = User.first(conditions: {email: params[:user][:email]})
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_to hot_topics_path
    else
      redirect_to request.referrer
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end
end
