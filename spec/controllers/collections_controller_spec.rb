require 'spec_helper'

describe Api::V1::CollectionsController do
  before :all do
    @options = { scope: CollectionSerializer, root: "collections" }
  end

  describe "GET #show" do
    before :each do
      get :show, id: collection.id
    end

    context "when the collection is found" do
      let(:collection) { create(:collection) }

      it "has a status code of 200" do
        expect(response.response_code).to eql 200
      end

      it "returns the requested collection" do
        collection_array = [collection]
        json = collection_array.active_model_serializer.new(collection_array, @options).to_json
        expect(response.body).to eql json
      end
    end

    context "when the collection is not found" do
      let(:collection) { double.tap { |dbl| dbl.stub(id: 1) } }

      it "has a status code of 404" do
        expect(response.response_code).to eql 404
      end
    end
  end

  describe "GET #index" do
    context "with no date specified" do
      before :each do
        @collections = [create(:collection), create(:collection)]
        get :index
      end

      it "has a status code of 200" do
        response.response_code.should eql 200
      end

      it "retrieves all collections" do
        json = @collections.active_model_serializer.new(@collections, @options).to_json
        expect(response.body).to eql json
      end
    end

    context "with a date specified" do
      before :each do
        without_timestamping_of(Collection) do
          @collection1 = create(:old_collection)
          @collection2 = create(:old_collection)
        end
        @last_updated = Time.now.utc
        @collection3 = create(:collection)

        get :index, last_updated: @last_updated
      end

      it "retrieves the collections updated after Time.now" do
        collections = [@collection3]
        json = collections.active_model_serializer.new(collections, @options).to_json
        response.body.should eql json
      end
    end
  end

  describe "POST #create" do
    before :each do
      post :create, request_payload, version(1)
    end

    context "with a valid collection" do
      let(:request_payload) do
        { collections: [{
            name: 'Summer Bible Study'
          }]
        }
      end

      it "increases the number of collections" do
        Collection.count.should eql 1
      end

      it "includes a location header in the response" do
        collection = Collection.last
        expect(response.header['Location']).to_not be_nil
        expect(response.header['Location']).to include("/api/collections/#{collection.id}")
      end

      it "returns json containing the collection" do
        collection = Collection.last
        json = collection.active_model_serializer.new(collection, @options).to_json
        expect(response.body).to eql json
      end

      it "adds a valid collection containing expected values" do
        Collection.last.name.should eql request_payload[:collections].first[:name]
      end

      it "has a status code of 201" do
        expect(response.response_code).to eql 201
      end
    end

    context "without a name specified" do
      let(:request_payload) do
        { collections: [{
            name: nil
          }]
        }
      end

      it "has a status code of 422" do
        response.response_code.should eql 422
      end

      it "returns an appropriate error message" do
        response.body.should include "Name can't be blank"
      end
    end
  end

  describe "DELETE #destroy" do
    context "without errors" do
      before :each do
        @collection1 = create(:collection)
        @collection2 = create(:collection)
        @collection3 = create(:collection)
      end

      let(:delete_collection) do
        delete :destroy, id: @collection2.id
      end

      it "has a status code of 204" do
        delete_collection
        expect(response.response_code).to eql 204
      end

      it "decreases the number of collections" do
        expect { delete_collection }.to change { Collection.count }.by(-1)
      end

      it "removes the expected collection" do
        delete_collection
        Collection.exists?(@collection2.id).should be_false
      end
    end

    context "with errors" do
      before :each do
        delete :destroy, id: 1
      end

      it "has a status code of 404" do
        expect(response.response_code).to eql 404
      end

      it "has an appropriate error message" do
        error = { error: 'The collection you were looking for could not be found' }
        expect(response.body).to eql error.to_json
      end
    end
  end

  describe "PATCH #update" do
    context "without errors" do
      before :each do
        @request_payload = {
          id: collection1.id,
          collections: [{
            name: 'new name'
          }]
        }
      end

      let(:collection1) { create(:collection) }

      let(:edit_collection) do
        patch :update, @request_payload
      end

      it "has a status code of 200" do
        edit_collection
        response.response_code.should eql 200
      end

      it "has no effect on the number of collections present in database" do
        expect { edit_collection }.not_to change { Collection.count }
      end

      it "edits the :name to a new value in database" do
        expect { edit_collection }.to change {
          Collection.find(collection1.id).name
        }.to(@request_payload[:collections].first[:name])
      end
    end

    context "trying to edit a non-existent collection" do
      before :each do
        @request_payload = {
          id: 1,
          collections: [{
            name: 'new name'
          }]
        }
      end

      before :each do
        patch :update, @request_payload
      end

      it "has a status code of 404" do
        response.response_code.should eql 404
      end

      it "has an appropriate error message" do
        error = { error: 'The collection you were looking for could not be found' }
        expect(response.body).to eql error.to_json
      end
    end
  end
end
