require 'spec_helper'

describe "AddCategorizations" do
  context "with a valid cateogization" do
    it "has a status code of 201"

    it "increases the number of categorizations by 1"

    it "has expected values after creation"

    it "returns json containing the categorization"
  end

  context "without a valid categorization" do
    it "has a status code of 422"

    it "returns an appropriate error message"
  end

  context "with a duplicate categorization" do
    it "has a status code of 409"

    it "returns an appropriate error message"
  end
end
