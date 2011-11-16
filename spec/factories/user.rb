FactoryGirl.define do 
  factory :user do
    sequence(:email){|n| "test#{n}@ourvoyce.com"}
    password 'abcd123'
    zip {|a| Zip.first.zip || a.association(:zip).zip }
    birth_year 1960
    country 'United States'
    state {|a| State.first.abbreviation || a.association(:state).abbreviation }
  end
end
