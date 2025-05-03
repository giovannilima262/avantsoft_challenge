FactoryBot.define do
  factory :sale do
    association :client
    association :toy
    created_at { Time.zone.now }
  end
end