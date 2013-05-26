FactoryGirl.define do
  factory :card do
    sequence(:reference) { |i| "Rom 3:#{i}" }
    sequence(:scripture) { |i| "Scripture content #{i}" }
    sequence(:subject) { |i| "Subject #{i}" }
    sequence(:translation) { |i| "Translation #{i}" }

    factory :old_card do
      old_time = 1.week.ago
      created_at old_time
      updated_at old_time
    end
  end
end
