require 'spec_helper'

describe Category do
  it "is invalid if name is missing" do
    category = FactoryGirl.build(:category, name: nil)
    expect(category).to have(1).errors_on(:name)
  end

  context "category creation" do
    it "changes the number of categories"
    it "should be valid"
  end

  describe "#updated_since" do
    it "includes all categories if no date is provided"
    it "includes the categories created after Time.now"
    it "does not include cards created before Time.now"
  end
end
