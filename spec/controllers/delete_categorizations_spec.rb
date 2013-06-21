require 'spec_helper'

describe "DeleteCategorizations" do
  before :each do
    @cat1 = create(:categorization)
    @cat2 = create(:categorization)
    @cat3 = create(:categorization)
  end

  let(:delete_cat) { delete "/api/categorizations/#{@cat2.id}", nil, version(1) }

  context "without errors" do
    it "has a status code of 204" do
      delete_cat
      response.response_code.should eql 204
    end

    it "decreases the number of categorizations" do
      expect { delete_cat }.to change { Categorization.count }.by(-1)
    end

    it "removes the expected categorization" do
      delete_cat
      Categorization.exists?(@cat2.id).should be_false
    end
  end

  context "trying to delete a non-existent categorization" do
    before :each do
      delete '/api/categorizations/1', nil, version(1)
    end

    it "has a status code of 404" do
      expect(response.response_code).to eql 404
    end

    it "has an appropriate error message" do
      error = { error: 'The categorization you were looking for could not be found' }
      expect(response.body).to eql error.to_json
    end
  end
end
