class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  before_save :set_state

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :remember_me, :zip, :country, :birth_year, :state
  attr_accessible :email, :zip, :country, :birth_year, :state, :password, :password_confirmation
  #include ActiveModel::SecurePassword
  #has_secure_password


  #Allow records to be updated without specifying the password
  #def update_with_password(params={})
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error params
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #if params[:password].strip.length == 0
      #super(params)
      #params.delete(:password)
      #params.delete(:password_confirmation)
    #end
    #params.delete(:current_password)
    #self.update_without_password(params)
    #super(params)
    #if password_required?
    #Rails.logger.error "REQUIRED"
    #self.update_with_password(params)
    #else
    #Rails.logger.error "NOT REQUIRED"
    #end
  #end	

  #Set the user's state based on their zip code
  def set_state
    if zip_changed? || state.blank?
      begin
        self.state = Zip.where(:zip => zip).first.state
      rescue
        Rails.logger.error "Error User#set_state"
      end
    end
  end


  def self.new_with_session(params, session)
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "User.new_with_session"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
    super.tap do |user|
      if data = session[:omniauth]
        user.user_tokens.build(:provider => data['provider'], :uid => data['uid'])
      end
    end
  end

  def apply_omniauth(omniauth)
    #Rails.logger.error "User.apply_omniauth"
    #add some info about the user
    #self.name = omniauth['user_info']['name'] if name.blank?
    #self.nickname = omniauth['user_info']['nickname'] if nickname.blank?

=begin
    unless omniauth['credentials'].blank?
      user_tokens.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
      #user_tokens.build(:provider => omniauth['provider'], 
      #                  :uid => omniauth['uid'],
      #                  :token => omniauth['credentials']['token'], 
      #                  :secret => omniauth['credentials']['secret'])
    else
      user_tokens.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    end
    #self.confirm!# unless user.email.blank?
=end
  end

  #def password_required?
  ##Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
  #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
  #Rails.logger.error "User.password_required?"
  #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
  #Rails.logger.error "~~~~~~~~~~~~~~~~~~~~~~~~~"
  #true
  #(user_tokens.empty? || !password.blank?) && super  
  #Rails.logger.error "USER_TOKENS.empty?: #{user_tokens.empty?}"
  #Rails.logger.error "!password.blank?: #{!password.blank?}"
  #Rails.logger.error "super: #{super}"

  #(user_tokens.empty? || !password.blank?) && super  
  #(new_record? || !password.blank?)
  #end


  validates :email, :presence => true, :uniqueness => true, :email => true
  #validates :password, :presence => true, :length => {:minimum => 6, :maximum => 8}, :on => :create #TODO - Check for updating password, as well
  validates :country, :presence => true, :inclusion => {:in => Country::COUNTRIES }
  validates :zip, :presence => true, :length => {:minimum => 4, :maximum => 5}, :us_zip => true
  #validates :state, :presence => true, :state => true
  validates :birth_year, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => lambda {|x| 100.years.ago.year}, :less_than_or_equal_to => lambda {|x| 13.years.ago.year} }


  has_many :user_tokens
  has_many :user_votes, :dependent => :destroy
  has_many :items, :through => :user_votes, :uniq => true

  has_many :favorites, :dependent => :destroy, :foreign_key => :user_id
  has_many :items, :through => :favorites, :uniq => true

end
