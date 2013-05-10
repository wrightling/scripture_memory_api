require 'spec_helper'

describe "RetrieveCategories" do
  before :all do
    @options = {scope: CategorySerializer, root: "categories"}
  end

  context "with no date specified" do
    before :each do
      @categories = [create(:category), create(:category)]
      get '/api/categories', nil, version(1)
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all categories" do
      json = @categories.active_model_serializer.new(@categories, @options).to_json
      response.body.should eql json
    end
  end

  context "with a date specified" do
    before :each do
      without_timestamping_of(Category) do
        @category1 = create(:old_category)
        @category2 = create(:old_category)
      end
      @last_updated = Time.now.utc
      @category3 = create(:category)

      get '/api/categories', {last_updated: @last_updated}, version(1)
    end

    it "retrieves the categories created after Time.now" do
      categories = [@category3]
      json = categories.active_model_serializer.new(categories, @options).to_json
      response.body.should eql json
    end
  end
end
