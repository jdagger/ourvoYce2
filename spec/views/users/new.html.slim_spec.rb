require 'spec_helper'

describe 'users/new' do
  before do
    user = stub_model(User)
    assign(:user, user)

    render
  end


  context 'Form has not been submitted' do
    it 'Contains a form with the appropriate fields' do
      rendered.should have_field("user_email")
      rendered.should have_field("user_password")
      rendered.should have_field("user_country")
      rendered.should have_field("user_zip")
      rendered.should have_field("user_birth_year")
      rendered.should have_field("membership_agreement")
      rendered.should have_selector("form input[@type='submit']")
    end
  end

  context 'The form has been submitted with invalid content' do

  end
end
