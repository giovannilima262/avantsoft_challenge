# spec/factories/toys.rb
FactoryBot.define do
  factory :toy do
    name { "Ball" }
    value { 19.99 }
  end
end