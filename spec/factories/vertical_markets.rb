# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do
  factory :vertical_market do |f|
    f.name { Faker::Lorem.word }
    f.description { Faker::Lorem.paragraph }
    f.parent false
  end
end
