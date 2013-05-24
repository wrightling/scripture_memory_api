require 'spec_helper'

describe "DeleteCards" do
  context "without errors" do
    before :each do
      @card1 = create(:card)
      @card2 = create(:card)
      @card3 = create(:card)

      delete "/api/cards/#{@card2.id}", nil, version(1)
    end

    it "has a status code of 204" do
      response.response_code.should eql 204
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
      delete "/api/cards/1", nil, version(1)
    end

    it { response.response_code.should eql 404 }

    it "has an appropriate error message" do
      error = { error: 'The card you were looking for could not be found' }
      response.body.should eql error.to_json
    end
  end
end
