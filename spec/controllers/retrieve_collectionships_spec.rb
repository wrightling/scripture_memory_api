require 'spec_helper'

describe "RetrieveCollectionships" do
  before :all do
    @options = { scope: CollectionshipSerializer, root: "collectionships" }
  end

  context "with no date specified" do
    before :each do
      @ships = [create(:collectionship), create(:collectionship)]
      get '/api/collectionships', nil, version(1)
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all collectionships" do
      json = @ships.active_model_serializer.new(@ships, @options).to_json
      response.body.should eql json
    end
  end

  context "with a date specified" do
    before :each do
      without_timestamping_of(Collectionship) do
        @ship1 = create(:old_collectionship)
        @ship2 = create(:old_collectionship)
      end
      @last_updated = Time.now.utc
      @ship3 = create(:collectionship)

      get '/api/collectionships', { last_updated: @last_updated }, version(1)
    end

    it "includes the collectionships updated after Time.now" do
      ships = [@ship3]
      json = ships.active_model_serializer.new(ships, @options).to_json
      response.body.should eql json
    end
  end
end
