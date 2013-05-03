require 'spec_helper'

describe "DeleteCards" do
  before :each do
    @card1 = FactoryGirl.create(:card)
    @card2 = FactoryGirl.create(:card)
    @card3 = FactoryGirl.create(:card)

    delete "/api/v1/cards/#{@card2.id}"
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
