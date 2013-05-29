require 'spec_helper'

describe "RetrieveCollections" do
  before :all do
    @options = { scope: CollectionSerializer, root: "collections" }
  end

  context "with no date specified" do
    before :each do
      @collections = [create(:collection), create(:collection)]
      get '/api/collections', nil, version(1)
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all collections" do
      json = @collections.active_model_serializer.new(@collections, @options).to_json
      expect(response.body).to eql json
    end
  end

  context "with a date specified" do
    before :each do
      without_timestamping_of(Collection) do
        @collection1 = create(:old_collection)
        @collection2 = create(:old_collection)
      end
      @last_updated = Time.now.utc
      @collection3 = create(:collection)

      get '/api/collections', {last_updated: @last_updated}, version(1)
    end

    it "retrieves the collections updated after Time.now" do
      collections = [@collection3]
      json = collections.active_model_serializer.new(collections, @options).to_json
      response.body.should eql json
    end
  end
end
