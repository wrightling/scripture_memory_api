require 'spec_helper'

describe "ShowCards" do
  before :all do
    @options = { scope: CardSerializer, root: "cards" }
  end

  before :each do
    get "/api/cards/#{card.id}", nil, version(1)
  end

  context "when the card is found" do
    let(:card) { create(:card) }

    it "has a status code of 200" do
      expect(response.response_code).to eql 200
    end

    it "returns the requested card" do
      card_array = [card]
      json = card_array.active_model_serializer.new(card_array, @options).to_json
      expect(response.body).to eql json
    end
  end

  context "when the card is not found" do
    let(:card) { double.tap { |dbl| dbl.stub(:id).and_return(1) } }

    it "has a status code of 404" do
      expect(response.response_code).to eql 404
    end
  end
end
