require 'spec_helper'

describe "ShowCollectionships" do
  before :all do
    @options = { scope: CollectionshipSerializer, root: "collectionships" }
  end

  before :each do
    get "/api/collectionships/#{ship.id}", nil, version(1)
  end

  context "when the collectionship is found" do
    let(:ship) { create(:collectionship) }

    it "has a status of 200" do
      expect(response.response_code).to eql 200
    end

    it "returns the requested collectionship" do
      ship_array = [ship]
      json = ship_array.active_model_serializer.new(ship_array, @options).to_json
      expect(response.body).to eql json
    end
  end

  context "when the collectionship is not found" do
    let(:ship) { double.tap { |dbl| dbl.stub(id: 1) } }

    it "has a status of 404" do
      expect(response.response_code).to eql 404
    end
  end
end
