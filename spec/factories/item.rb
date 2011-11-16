FactoryGirl.define do 
  factory :item do
    sequence(:name){|n| "item_#{n}"}
  end
end
