FactoryGirl.define do
  factory :categorization do
    sequence(:card_id) { |i| i }
    sequence(:category_id) { |i| i }

    factory :old_categorization do
      time = 1.week.ago
      created_at time
      updated_at time
    end
  end
end
