require 'spec_helper'

describe "DeleteCollections" do
  context "without errors" do
    before :each do
      @collection1 = create(:collection)
      @collection2 = create(:collection)
      @collection3 = create(:collection)
    end

    let(:delete_collection) do
      delete "/api/collections/#{@collection2.id}", nil, version(1)
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
      delete '/api/collections/1', nil, version(1)
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
