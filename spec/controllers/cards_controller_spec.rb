require 'spec_helper'

describe Api::V1::CardsController do
  before :all do
    @options = {scope: CardSerializer, root: "cards"}
  end

  describe "GET #show" do
    before :each do
      get :show, id: card.id
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

  describe "GET #index" do
    context "with no date specified" do
      before :each do
        @cards = [create(:card), create(:card)]
        get :index
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

        get :index, last_updated: @last_updated
      end

      it "retrieves the cards updated after Time.now" do
        cards = [@card3]
        json = cards.active_model_serializer.new(cards, @options).to_json
        response.body.should eql json
      end
    end
  end

  describe "POST #create" do
    before :each do
      post :create, request_payload
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

  describe "DELETE #destroy" do
    context "without errors" do
      before :each do
        @card1 = create(:card)
        @card2 = create(:card)
        @card3 = create(:card)

        delete :destroy, id: @card2.id
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
        delete :destroy, id: 1
      end

      it { response.response_code.should eql 404 }

      it "has an appropriate error message" do
        error = { error: 'The card you were looking for could not be found' }
        response.body.should eql error.to_json
      end
    end
  end

  describe "PATCH #update" do
    context "without errors" do
      let(:card1) { create(:card) }

      before :each do
        @request_payload = {
          id: card1.id,
          cards: [{
            reference: 'John 5:24'
          }]
        }
      end

      let(:edit_reference) { patch :update,  @request_payload }

      it "has a status code of 200" do
        edit_reference
        response.response_code.should eql 200
      end

      it "has no effect on the number of cards present" do
        expect { edit_reference }.not_to change { Card.count }
      end

      it "edits the reference to a new value" do
        expect { edit_reference }.to change {
          Card.find(card1.id).reference
        }.to(@request_payload[:cards].first[:reference])
      end
    end

    context "trying to edit a non-existent card" do
      before :each do
        @request_payload = {
          id: 1,
          cards: [{
            reference: 'John 5:24'
          }]
        }

        patch :update, @request_payload
      end

      it { response.response_code.should eql 404 }

      it "has an appropriate error message" do
        error = { error: 'The card you were looking for could not be found' }
        response.body.should eql error.to_json
      end
    end
  end
end
