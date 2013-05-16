require 'spec_helper'

describe "AddMultipleCategorizations" do
  before :all do
    @options = { scope: CategorizationSerializer, root: "categorizations" }
  end

  before :each do
    post '/api/categorizations',
      request_payload,
      version(1)
  end

  describe "#create" do
    subject { response }

    let(:cat1) { build(:categorization) }
    let(:cat2) { build(:categorization) }
    let(:request_payload) do
      {categorizations: [
        {card_id: cat1.card.id, category_id: cat1.category.id},
        {card_id: cat2.card.id, category_id: cat2.category.id}]
      }
    end

    context "with valid categorizations" do
      its(:response_code) { should eql 201 }

      it "creates two categorizations if two are specified" do
        Categorization.count.should eql 2
      end
    end

    context "with only invalid categorizations" do
      it "responds with a 422 status"
      it "responds with error messages"
    end

    context "with partial success" do
      it "responds with a 201 status"
      it "provides error mesages for failures"
    end
  end
end
