class Admin::UsersController < Admin::ApplicationController
  def index
    page = params[:page] || 1
    sort_column = params[:c]
    sort_direction = params[:d] == "up" ? "asc" : "desc"

    @users = User.paginate(:page => page, :per_page => 50)

    unless sort_column.blank?
      @users = @users.order("#{sort_column} #{sort_direction}")
    end
  end

  def confirm
    @user = User.find(params[:user_id])
    @user.confirmed_at = Time.now
    if @user.save
      flash[:success] = "Successfully confirmed user"
      redirect_to admin_user_path(@user)
    else
      flash[:error] = "Failed to confirm user"
      @user.confirmed_at = nil
      render :edit
    end
  end

  def show 
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new do |u|
      u.email = params[:user][:email]
      u.password = params[:user][:password]
      u.country = params[:user][:country]
      u.zip = params[:user][:zip]
      u.birth_year = params[:user][:birth_year]
    end

    if @user.save
      flash[:success] = 'Successfully created user'
      redirect_to edit_admin_user_path(@user)
    else
      flash[:error] = 'Failed to create user'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    #@user.update_attributes(params[:user])
    @user.email = params[:user][:email]
    unless params[:user][:password].blank?
      @user.password = params[:user][:password]
    end
    @user.country = params[:user][:country]
    @user.zip = params[:user][:zip]
    @user.birth_year = params[:user][:birth_year]

    if @user.save
      flash[:success] = 'Successfully updated user'
    else
      flash[:error] = 'Failed to save user'
    end
    render :edit
  end

  def destroy
    User.delete(params[:id])
    flash[:success] = 'Successfully deleted user'
    redirect_to admin_users_path
  end

  def suggest_by_name
    results = User.lookup_by_email(params[:name]).to_json
    render :json => results
  end

  def find_by_autocomplete
    lookup_value = params['item-lookup']

    # lookup_value should have form: name (id)
    if lookup_value =~ /.*\((?<id>\d*?)\)$/
      redirect_to admin_user_path(Regexp.last_match(:id))
    else
      redirect_to request.referrer, :notice => 'Lookup not in valid format'
    end
  end
end
