require 'spec_helper'

describe "AddCategorizations" do
  before :each do
    post '/api/categorizations',
      request_payload,
      version(1)
  end

  context "with a valid cateogization" do
    subject { response }

    let(:card) { create(:card) }
    let(:category) { create(:category) }

    let(:request_payload) do
      { categorizations: [{ card_id: card.id, category_id: category.id }] }
    end

    its(:response_code) { should eql 201 }

    it "increases the number of categorizations by 1" do
      Categorization.count.should eql 1
    end

    it "has expected values after creation" do
      Categorization.last.card_id.should eql card.id
      Categorization.last.category_id.should eql category.id
    end

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
