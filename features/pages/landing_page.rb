class LandingPage
  URL = "/"

  def initialize(session)
    @session = session
  end

  def visit 
    @session.visit URL
  end
end
