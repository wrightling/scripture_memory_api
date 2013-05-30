require 'spec_helper'

describe "DeleteCollectionships" do
  before :each do
    @ship1 = create(:collectionship)
    @ship2 = create(:collectionship)
    @ship3 = create(:collectionship)
  end

  context "without errors" do
    let(:delete_ship) { delete "/api/collectionships/#{@ship2.id}", nil, version(1) }

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
      delete '/api/collectionships/1', nil, version(1)
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
