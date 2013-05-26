require 'spec_helper'

describe "ShowCategories" do
  before :all do
    @options = { scope: CategorySerializer, root: "categories" }
  end

  before :each do
    get "/api/categories/#{category.id}", nil, version(1)
  end

  context "when the category is found" do
    let(:category) { create(:category) }

    it "has a status code of 200" do
      expect(response.response_code).to eql 200
    end

    it "returns the requested category" do
      category_array = [category]
      json = category_array.active_model_serializer.new(category_array, @options).to_json
      expect(response.body).to eql json
    end
  end

  context "when the category is not found" do
    let(:category) { double.tap { |dbl| dbl.stub(id: 1) } }

    it "has a status code of 404" do
      expect(response.response_code).to eql 404
    end
  end
end
