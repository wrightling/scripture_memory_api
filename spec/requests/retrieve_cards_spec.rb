require 'spec_helper'

describe "RetrieveCards" do
  before :each do
    @card1 = Card.create(reference: 'Rom 3:23', scripture: 'all have sinned', subject: '')
    @card2 = Card.create(reference: 'Rom 6:23', scripture: 'the wages of sin is death', subject: '')
  end

  context "with no date specified" do
    before :each do
      get cards_path
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all cards" do
      response.body.should include(@card1.reference, @card1.scripture,
                                   @card2.reference, @card2.reference)
    end
  end

  context "with a date specified" do
    before :each do
      last_updated = Time.now
      @card3 = Card.create(reference: 'Rom 12:1', scripture: 'Therefore I urge..', subject: '')
      get cards_path, last_updated: last_updated
    end

    it "retrieves the cards created before Time.now" do
      response.body.should include(@card1.reference, @card1.scripture,
                                   @card2.reference, @card2.scripture)
    end

    it "does not include the card created after Time.now" do
      response.body.should_not include(@card3.reference, @card3.scripture)
    end
  end
end
