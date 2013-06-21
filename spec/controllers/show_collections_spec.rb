require 'spec_helper'

describe "ShowCollections" do
  before :all do
    @options = { scope: CollectionSerializer, root: "collections" }
  end

  before :each do
    get "/api/collections/#{collection.id}", nil, version(1)
  end

  context "when the collection is found" do
    let(:collection) { create(:collection) }

    it "has a status code of 200" do
      expect(response.response_code).to eql 200
    end

    it "returns the requested collection" do
      collection_array = [collection]
      json = collection_array.active_model_serializer.new(collection_array, @options).to_json
      expect(response.body).to eql json
    end
  end

  context "when the collection is not found" do
    let(:collection) { double.tap { |dbl| dbl.stub(id: 1) } }

    it "has a status code of 404" do
      expect(response.response_code).to eql 404
    end
  end
end
