#https://github.com/plataformatec/devise
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end

