# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :collection do
    sequence(:name) { |i| "collection#{i}" }

    factory :old_collection do
      old_time = 1.week.ago
      created_at old_time
      updated_at old_time
    end
  end
end
