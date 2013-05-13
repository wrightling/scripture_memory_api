require 'spec_helper'

describe "AddCategorizations" do
  before :all do
    @options = { scope: CategorizationSerializer, root: "categorizations" }
  end

  before :each do
    post '/api/categorizations',
      request_payload,
      version(1)
  end

  let(:card) { create(:card) }
  let(:category) { create(:category) }

  context "with a valid cateogization" do
    subject { response }

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

    it "returns json containing the categorization" do
      categorization = Categorization.last
      json = categorization.active_model_serializer.new(categorization,
                                                        @options).to_json
      expect(response.body).to eql json
    end
  end

  context "without a valid categorization" do
    subject { response }

    let(:request_payload) do
      { categorizations: [{ card_id: nil, category_id: nil }] }
    end

    its(:response_code) { should eql 422 }
    its(:body) { should include("\"card_id\":[\"can't be blank\"]",
                                "\"category_id\":[\"can't be blank\"]") }
  end

  context "with a duplicate categorization" do
    let(:request_payload) do
      { categorizations: [{ card_id: card.id, category_id: category.id }] }
    end

    let(:duplicate_post) do
      post '/api/categorizations',
        request_payload,
        version(1)
    end

    it "does not modify the number of categorizations" do
      expect { duplicate_post }.not_to change { Categorization.count }
    end

    it "has a status code of 409" do
      duplicate_post
      expect(response.response_code).to eql 409
    end

    it "returns an appropriate error message" do
      duplicate_post
      expect(response.body).to match /link.*already exists/
    end
  end
end
