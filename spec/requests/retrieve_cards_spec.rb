require 'spec_helper'

describe "RetrieveCards" do
  context "with no date specified" do
    before :each do
      @card1 = FactoryGirl.create(:card)
      @card2 = FactoryGirl.create(:card)
      get '/api/cards', nil, {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all cards" do
      response.body.should eql Card.all.to_json
    end
  end

  context "with a date specified" do
    before :each do
      without_timestamping_of(Card) do
        @card1 = FactoryGirl.create(:old_card)
        @card2 = FactoryGirl.create(:old_card)
      end
      @last_updated = Time.now.utc
      @card3 = FactoryGirl.create(:card)

      get '/api/cards',
        {last_updated: @last_updated},
        {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it "retrieves the cards created after Time.now" do
      response.body.should eql Card.updated_since(@last_updated).to_json
    end
  end
end
