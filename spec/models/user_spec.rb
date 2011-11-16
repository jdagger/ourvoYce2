require 'spec_helper'

describe User do
  context 'Validators' do
    before do
      Factory(:state, abbreviation: 'NC')
      Factory(:state, abbreviation: 'AL')
      Factory(:zip, zip: 28801)
      Factory(:user, email: 'test@ourvoyce.com')
    end

    context "#email" do
      it{ should have_valid(:email).when('test1@ourvoyce.com', 'b.1.2@test.com') }
      it{ should_not have_valid(:email).when('test@ourvoyce.com', 'abc', '', nil) }
    end

    context "#password" do
      #TODO - Verify password requirements. Add pass and fail examples
      
      it{ should have_valid(:password).when('abcd1234') }
      it{ should_not have_valid(:password).when(nil, '', 'abcde', '12345678901234') }
    end

    context "#country" do
      it{ should have_valid(:country).when('United States') }
      it{ should_not have_valid(:country).when(nil, '', 'USA') }
    end

    context "#zip" do
      it{ should have_valid(:zip).when(28801) }

      #TODO - Find a four digit, valid zip to validate
      it{ should_not have_valid(:zip).when(nil, 0, '', 'abcde', 99999, 00000, 000, 00000) }
    end

    context "#state" do
      it{ should have_valid(:state).when('NC', 'AL') }
      it{ should_not have_valid(:state).when(nil, '', 'nc', 'NA') }
    end

    context '#birth_year' do
      it{ should have_valid(:birth_year).when(1970) }

      #TODO - Verify minimum acceptible age
      it{ should_not have_valid(:birth_year).when(nil, 0, '', 1900, 13.years.ago) }
    end
  end
end
