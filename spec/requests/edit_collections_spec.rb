require 'spec_helper'

describe "EditCollections" do
  before :each do
    @request_payload = {
      collections: [{
        name: 'new name'
      }]
    }
  end

  context "without errors" do
    before :each do
      @collection1 = create(:collection)
    end

    let(:edit_collection) do
      put "/api/collections/#{@collection1.id}", @request_payload, version(1)
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
        Collection.find(@collection1.id).name
      }.to(@request_payload[:collections].first[:name])
    end
  end

  context "trying to edit a non-existent collection" do
    before :each do
      put '/api/collections/1', @request_payload, version(1)
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
