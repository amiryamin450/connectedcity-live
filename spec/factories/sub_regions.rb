# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sub_region do
    name "MyString"
    description "MyText"
    region_id 1
  end
end
