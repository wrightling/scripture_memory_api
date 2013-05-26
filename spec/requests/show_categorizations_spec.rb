require 'spec_helper'

describe "ShowCategorizations" do
  before :all do
    @options = { scope: CategorizationSerializer, root: "categorizations" }
  end

  before :each do
    get "/api/categorizations/#{cat.id}", nil, version(1)
  end

  context "when the categorization is found" do
    let(:cat) { create(:categorization) }

    it "has a status of 200" do
      expect(response.response_code).to eql 200
    end

    it "returns the requested categorization" do
      cat_array = [cat]
      json = cat_array.active_model_serializer.new(cat_array, @options).to_json
      expect(response.body).to eql json
    end
  end

  context "when the categorization is not found" do
    let(:cat) { double.tap { |dbl| dbl.stub(id: 1) } }

    it "has a status of 404" do
      expect(response.response_code).to eql 404
    end
  end
end
