require 'spec_helper'

describe "RetrieveCategories" do
  context "with no date specified" do
    before :each do
      @category1 = FactoryGirl.create(:category)
      @category2 = FactoryGirl.create(:category)
      get '/api/categories', nil, {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all categories" do
      response.body.should eql Category.all.to_json
    end
  end

  context "with a date specified" do
    before :each do
      without_timestamping_of(Category) do
        @category1 = FactoryGirl.create(:old_category)
        @category2 = FactoryGirl.create(:old_category)
      end
      @last_updated = Time.now.utc
      @category3 = FactoryGirl.create(:category)

      get '/api/categories',
        {last_updated: @last_updated},
        {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it "retrieves the categories created after Time.now" do
      response.body.should eql Category.updated_since(@last_updated).to_json
    end
  end
end
