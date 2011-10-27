class Admin::UsersController < Admin::ApplicationController
  def index
    page = params[:page] || 1
    @users = User.paginate(:page => page)
  end

  def show 
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(params[:user])
    flash[:success] = 'Successfully created user'
    render :edit
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    flash[:success] = 'Successfully updated user'
    render :edit
  end

  def destroy
    User.delete(params[:id])
    flash[:success] = 'Successfully deleted user'
    redirect_to admin_users_path
  end
end
