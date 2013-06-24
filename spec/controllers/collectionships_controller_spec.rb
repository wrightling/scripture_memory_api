require 'spec_helper'

describe Api::V1::CollectionshipsController do
  before :all do
    @options = { scope: CollectionshipSerializer, root: "collectionships" }
  end

  describe "GET #show" do
    before :each do
      get :show, id: ship.id
    end

    context "when the collectionship is found" do
      let(:ship) { create(:collectionship) }

      it "has a status of 200" do
        expect(response.response_code).to eql 200
      end

      it "returns the requested collectionship" do
        ship_array = [ship]
        json = ship_array.active_model_serializer.new(ship_array, @options).to_json
        expect(response.body).to eql json
      end
    end

    context "when the collectionship is not found" do
      let(:ship) { double.tap { |dbl| dbl.stub(id: 1) } }

      it "has a status of 404" do
        expect(response.response_code).to eql 404
      end
    end
  end

  describe "GET #index" do
    context "with no date specified" do
      before :each do
        @ships = [create(:collectionship), create(:collectionship)]
        get :index
      end

      it "has a status code of 200" do
        response.response_code.should eql 200
      end

      it "retrieves all collectionships" do
        json = @ships.active_model_serializer.new(@ships, @options).to_json
        response.body.should eql json
      end
    end

    context "with a date specified" do
      before :each do
        without_timestamping_of(Collectionship) do
          @ship1 = create(:old_collectionship)
          @ship2 = create(:old_collectionship)
        end
        @last_updated = Time.now.utc
        @ship3 = create(:collectionship)

        get :index, last_updated: @last_updated
      end

      it "includes the collectionships updated after Time.now" do
        ships = [@ship3]
        json = ships.active_model_serializer.new(ships, @options).to_json
        response.body.should eql json
      end
    end
  end

  describe "POST #create" do
    before :each do
      post :create, request_payload
    end

    let(:card) { create(:card) }
    let(:collection) { create(:collection) }

    context "with a valid collectionship" do
      subject { response }

      let(:request_payload) do
        { collectionships: [{ card_id: card.id, collection_id: collection.id }] }
      end

      its(:response_code) { should eql 201 }

      it "has expected values after creation" do
        Collectionship.last.card_id.should eql card.id
        Collectionship.last.collection_id.should eql collection.id
      end

      it "returns json containing the collectionship" do
        collectionship = Collectionship.last
        json = collectionship.active_model_serializer.new(collectionship,
                                                          @options).to_json
        expect(response.body).to eql json
      end

      it "includes a location header in the response" do
        collectionship = Collectionship.last
        expect(response.header['Location']).to_not be_nil
        expect(response.header['Location']).to include ("/api/collectionships/#{collectionship.id}")
      end
    end

    context "without a valid collectionship" do
      subject { response }

      let(:request_payload) do
        { collectionships: [{ card_id: nil, collection_id: nil }] }
      end

      its(:response_code) { should eql 422 }
      its(:body) { should include("\"card_id\":[\"can't be blank\"]",
                                  "\"collection_id\":[\"can't be blank\"]") }
    end

    context "with a duplicate collectionship" do
      let(:request_payload) do
        { collectionships: [{ card_id: card.id, collection_id: collection.id }] }
      end

      let(:duplicate_post) do
        post :create, request_payload
      end

      it "does not modify the number of collectionships" do
        expect { duplicate_post }.not_to change { Collectionship.count }
      end

      it "has a status code of 409" do
        duplicate_post
        expect(response.response_code).to eql 409
      end

      it "reutrns an appropriate error message" do
        duplicate_post
        expect(response.body).to match /link.*already exists/
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @ship1 = create(:collectionship)
      @ship2 = create(:collectionship)
      @ship3 = create(:collectionship)
    end

    context "without errors" do
      let(:delete_ship) { delete :destroy, id: @ship2.id }

      it "has a status code of 204" do
        delete_ship
        response.response_code.should eql 204
      end

      it "decreases the number of collectionships" do
        expect { delete_ship }.to change { Collectionship.count }.by(-1)
      end

      it "removes the expected collectionship" do
        delete_ship
        Collectionship.exists?(@ship2.id).should be_false
      end
    end

    context "trying to delete a non-existent collectionship" do
      before :each do
        delete :destroy, id: 1
      end

      it "has a status code of 404" do
        expect(response.response_code).to eql 404
      end

      it "has an appropriate error message" do
        error = { error: 'The collectionship you were looking for could not be found' }
        expect(response.body).to eql error.to_json
      end
    end
  end
end
