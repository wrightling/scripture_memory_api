FactoryGirl.define do
  factory :category do
    sequence(:name) { |i| "category#{i}" }
  end
end
