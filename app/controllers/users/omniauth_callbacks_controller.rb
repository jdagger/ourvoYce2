class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if u = User.find_by_omniauth(auth) #if user is found with credentials, sign them in
      flash.notice = "Signed in!"
      sign_in_and_redirect u
    elsif User.find_by_email(auth['info']['email']).nil?  #if email is not already registered
      u = User.new :email => auth['info']['email'] #make new user
      ap auth
      ap u


      u.save( :validate => false )
      u.omniauth_providers.create :provider => auth['provider'], :uid => auth['uid'] 
      sign_in_and_redirect u
    end
  end
  
  def auth
    request.env['omniauth.auth']
  end








  #def identity
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "Omniauth callback - identity"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
  #end 

  #def method_missing(provider)
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "Omniauth - method_missing"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"

=begin
    if !User.omniauth_providers.index(provider).nil?
      #omniauth = request.env["omniauth.auth"]
      omniauth = env["omniauth.auth"]

      if current_user #or User.find_by_email(auth.recursive_find_by_key("email"))
        current_user.user_tokens.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
        flash[:notice] = "Authentication successful"
        redirect_to edit_user_registration_path
      else

        authentication = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

        if authentication
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
          sign_in_and_redirect(:user, authentication.user)
          #sign_in_and_redirect(authentication.user, :event => :authentication)
        else

          #create a new user
          unless omniauth.recursive_find_by_key("email").blank?
            user = User.find_or_initialize_by_email(:email => omniauth.recursive_find_by_key("email"))
          else
            user = User.new
          end

          user.apply_omniauth(omniauth)
          #user.confirm! #unless user.email.blank?

          if user.save
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider'] 
            sign_in_and_redirect(:user, user)
          else
            session[:omniauth] = omniauth.except('extra')
            redirect_to new_user_registration_url
          end
        end
      end
    end
=end
  #end

    #def passthru
      #render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    #end
end
