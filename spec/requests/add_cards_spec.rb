require 'spec_helper'

describe "AddCards" do
  before :all do
    @options = {scope: CardSerializer, root: "cards"}
  end

  before :each do
    post '/api/cards', request_payload, version(1)
  end

  context "with a valid card" do
    let(:request_payload) do
      { cards: [{
          subject: 'some subject',
          reference: 'Rom 3:23',
          scripture: 'For all have sinned...',
          translation: 'NASB'
        }]
      }
    end

    it "has a status code of 201" do
      response.response_code.should eql 201
    end

    it "increases the number of cards" do
      Card.count.should eql 1
    end

    it "has expected values" do
      card = Card.last
      card.subject.should eql request_payload[:cards].first[:subject]
      card.translation.should eql request_payload[:cards].first[:translation]
    end

    it "returns json containing the card" do
      card = Card.last
      json = card.active_model_serializer.new(card, @options).to_json
      expect(response.body).to eql json
    end

    it "includes a location header in the response" do
      card = Card.last
      expect(response.header['Location']).to_not be_nil
      expect(response.header['Location']).to include("/api/cards/#{card.id}")
    end
  end

  context "without subject and reference" do
    let(:request_payload) do
      { cards: [{
          scripture: 'For all have sinned...'
        }]
      }
    end

    it "has a status code of 422" do
      response.response_code.should eql 422
    end

    it "returns an appropriate error message" do
      response.body.should include 'Please include a reference or subject'
    end
  end
end
