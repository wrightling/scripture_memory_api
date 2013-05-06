FactoryGirl.define do
  factory :category do
    sequence(:name) { |i| "category#{i}" }

    factory :old_category do
      old_time = 1.week.ago
      created_at old_time
      updated_at old_time
    end
  end
end
