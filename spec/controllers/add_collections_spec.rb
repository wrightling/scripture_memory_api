require 'spec_helper'

describe "AddCollections" do
  before :all do
    @options = { scope: CollectionSerializer, root: "collections" }
  end

  before :each do
    post '/api/collections', request_payload, version(1)
  end

  context "with a valid collection" do
    let(:request_payload) do
      { collections: [{
          name: 'Summer Bible Study'
        }]
      }
    end

    it "increases the number of collections" do
      Collection.count.should eql 1
    end

    it "includes a location header in the response" do
      collection = Collection.last
      expect(response.header['Location']).to_not be_nil
      expect(response.header['Location']).to include("/api/collections/#{collection.id}")
    end

    it "returns json containing the collection" do
      collection = Collection.last
      json = collection.active_model_serializer.new(collection, @options).to_json
      expect(response.body).to eql json
    end

    it "adds a valid collection containing expected values" do
      Collection.last.name.should eql request_payload[:collections].first[:name]
    end

    it "has a status code of 201" do
      expect(response.response_code).to eql 201
    end
  end

  context "without a name specified" do
    let(:request_payload) do
      { collections: [{
          name: nil
        }]
      }
    end

    it "has a status code of 422" do
      response.response_code.should eql 422
    end

    it "returns an appropriate error message" do
      response.body.should include "Name can't be blank"
    end
  end
end
