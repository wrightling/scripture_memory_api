require 'spec_helper'

describe "AddCards" do
  before :all do
    @options = {scope: CardSerializer, root: "cards"}
  end

  before :each do
    post '/api/cards', request_payload,
      {'HTTP_ACCEPT' => 'application/smapi.v1'}
  end

  context "with a valid card" do
    let(:request_payload) do
      { card: {
          subject: 'some subject',
          reference: 'Rom 3:23',
          scripture: 'For all have sinned...'
        }
      }
    end

    it "has a status code of 201" do
      response.response_code.should eql 201
    end

    it "increases the number of cards" do
      Card.count.should eql 1
    end

    it "has expected values" do
      Card.last.subject.should eql request_payload[:card][:subject]
    end

    it "returns json containing the card" do
      card = Card.last
      json = card.active_model_serializer.new(card, @options).to_json
      expect(response.body).to eql json
    end
  end

  context "without subject and reference" do
    let(:request_payload) do
      { card: {
          scripture: 'For all have sinned...'
        }
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
