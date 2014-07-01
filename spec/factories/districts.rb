# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :district do
    name "MyString"
    description "MyText"
    city_id 1
  end
end
