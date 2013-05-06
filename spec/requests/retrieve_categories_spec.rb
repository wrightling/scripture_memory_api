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
      response.body.should include(@category1.name,
                                   @category2.name)
    end
  end

  context "with a date specified" do
    it "does not include the category created before Time.now"
    it "retrieves the categories created after Time.now"
  end
end
