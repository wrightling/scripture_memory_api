FactoryGirl.define do
  factory :collectionship do
    sequence(:card_id) { create(:card).id }
    sequence(:collection_id) { create(:collection).id }

    factory :old_collectionship do
      time = 1.week.ago
      created_at time
      updated_at time
    end
  end
end
