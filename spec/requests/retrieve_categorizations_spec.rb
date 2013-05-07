require 'spec_helper'

describe "RetrieveCategorizations" do
  context "with no date specified" do
    before :each do
      @cat1 = FactoryGirl.create(:categorization)
      @cat2 = FactoryGirl.create(:categorization)
      get '/api/categorizations', nil,
        {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all categorizations" do
      response.body.should eql Categorization.all.to_json
    end
  end

  context "with a date specified" do
    before :each do
      without_timestamping_of(Categorization) do
        @cat1 = FactoryGirl.create(:old_categorization)
        @cat2 = FactoryGirl.create(:old_categorization)
      end
      @last_updated = Time.now.utc
      @cat3 = FactoryGirl.create(:categorization)

      get '/api/categorizations',
        {last_updated: @last_updated},
        {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it "includes the categorizations created after Time.now" do
      response.body.should eql Categorization.updated_since(@last_updated).to_json
    end
  end
end
