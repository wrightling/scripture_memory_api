require 'spec_helper'

describe "AddCollectionships" do
  before :all do
    @options = { scope: CollectionshipSerializer, root: "collectionships" }
  end

  before :each do
    post '/api/collectionships', request_payload, version(1)
  end

  let(:card) { create(:card) }
  let(:collection) { create(:collection) }

  context "with a valid collectionship" do
    subject { response }

    let(:request_payload) do
      { collectionships: [{ card_id: card.id, collection_id: collection.id }] }
    end

    its(:response_code) { should eql 201 }

    it "has expected values after creation" do
      Collectionship.last.card_id.should eql card.id
      Collectionship.last.collection_id.should eql collection.id
    end

    it "returns json containing the collectionship" do
      collectionship = Collectionship.last
      json = collectionship.active_model_serializer.new(collectionship,
                                                        @options).to_json
      expect(response.body).to eql json
    end

    it "includes a location header in the response" do
      collectionship = Collectionship.last
      expect(response.header['Location']).to_not be_nil
      expect(response.header['Location']).to include ("/api/collectionships/#{collectionship.id}")
    end
  end

  context "without a valid collectionship" do
    subject { response }

    let(:request_payload) do
      { collectionships: [{ card_id: nil, collection_id: nil }] }
    end

    its(:response_code) { should eql 422 }
    its(:body) { should include("\"card_id\":[\"can't be blank\"]",
                                "\"collection_id\":[\"can't be blank\"]") }
  end

  context "with a duplicate collectionship" do
    let(:request_payload) do
      { collectionships: [{ card_id: card.id, collection_id: collection.id }] }
    end

    let(:duplicate_post) do
      post '/api/collectionships', request_payload, version(1)
    end

    it "does not modify the number of collectionships" do
      expect { duplicate_post }.not_to change { Collectionship.count }
    end

    it "has a status code of 409" do
      duplicate_post
      expect(response.response_code).to eql 409
    end

    it "reutrns an appropriate error message" do
      duplicate_post
      expect(response.body).to match /link.*already exists/
    end
  end
end
