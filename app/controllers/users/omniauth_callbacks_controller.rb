class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def confirm_owns_account
    @auth = session[:auth]
    @user = User.find_by_email @auth['info']['email']

    if @user.valid_password? params[:password]
      @user.omniauth_providers.create :provider => @auth['provider'], :uid => @auth['uid']
      flash.notice = "Signed in. Facebook signin has been added to your account!"
      session.delete 'auth'
      sign_in_and_redirect @user
    else
      flash.now[:notice] = "Sorry this password is incorrect. Try again?" 
      render :confirm_provider_form 
    end
  end

  def facebook
    if o_user
      flash.notice = "Signed in!"
      sign_in_via_omniauth o_user
    elsif @user = User.find_by_email(auth['info']['email']) #email in use 
      session[:auth] = auth
      render :confirm_provider_form 
    else #email not registered
      sign_in_via_omniauth register_new_user
    end
  end

  private
    def auth
      request.env['omniauth.auth']
    end
    def o_user
      @o_user ||= User.find_by_omniauth(auth) 
    end
    def provider
      @provider ||= o_user.omniauth_providers.find_by_provider(auth['provider'])
    end
    def register_new_user
      u = User.new :email => auth['info']['email'] #make new user
      u.save( :validate => false )
      u.omniauth_providers.create :provider => auth['provider'], :uid => auth['uid']
      u
    end
    def sign_in_via_omniauth(user)
      user.current_omniauth_providor_id = provider.id
      sign_in_and_redirect user
    end

end
