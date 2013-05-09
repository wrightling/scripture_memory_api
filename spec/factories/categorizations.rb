FactoryGirl.define do
  factory :categorization do
    sequence(:card_id) { create(:card).id }
    sequence(:category_id) { create(:category).id }

    factory :old_categorization do
      time = 1.week.ago
      created_at time
      updated_at time
    end
  end
end
