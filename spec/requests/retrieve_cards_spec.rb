require 'spec_helper'

describe "RetrieveCards" do
  before :all do
    @options = {scope: CardSerializer, root: "cards"}
  end

  context "with no date specified" do
    before :each do
      @cards = [create(:card), create(:card)]
      get '/api/cards', nil, version(1)
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all cards" do
      json = @cards.active_model_serializer.new(@cards, @options).to_json
      response.body.should eql json
    end
  end

  context "with a date specified" do
    before :each do
      without_timestamping_of(Card) do
        @card1 = create(:old_card)
        @card2 = create(:old_card)
      end
      @last_updated = Time.now.utc
      @card3 = create(:card)

      get '/api/cards', {last_updated: @last_updated}, version(1)
    end

    it "retrieves the cards created after Time.now" do
      cards = [@card3]
      json = cards.active_model_serializer.new(cards, @options).to_json
      response.body.should eql json
    end
  end
end
