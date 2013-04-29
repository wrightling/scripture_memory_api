require 'spec_helper'

describe "RetrieveCards" do
  before :each do
    Card.create(reference: 'Rom 3:23', scripture: 'all have sinned', subject: '')
    Card.create(reference: 'Rom 6:23', scripture: 'the wages of sin is death', subject: '')
  end

  context "with no date specified" do
    before :each do
      get cards_path
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all cards" do
      response.body.should include(Card.first.reference, Card.first.scripture,
                                   Card.last.reference, Card.last.reference)
    end
  end

  context "with a date specified" do
    it "retrieves only cards since last_update"
  end
end
