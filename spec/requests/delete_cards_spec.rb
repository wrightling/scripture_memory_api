require 'spec_helper'

describe "DeleteCards" do
  context "without errors" do
    before :each do
      @card1 = FactoryGirl.create(:card)
      @card2 = FactoryGirl.create(:card)
      @card3 = FactoryGirl.create(:card)

      delete "/api/cards/#{@card2.id}", nil,
        {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "decreases the number of cards" do
      Card.count.should eql 2
    end

    it "removes the expected card" do
      Card.exists?(@card2.id).should be_false
    end
  end

  context "trying to delete a non-existent card" do
    before :each do
      delete "/api/cards/1", nil,
        {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it { response.response_code.should eql 404 }

    it "has an appropriate error message" do
      error = { error: 'The card you were looking for could not be found' }
      response.body.should eql error.to_json
    end
  end
end
