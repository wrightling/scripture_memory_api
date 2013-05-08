require 'spec_helper'

describe "DeleteCategories" do
  context "without errors" do
    before :each do
      @category1 = create(:category)
      @category2 = create(:category)
      @category3 = create(:category)
    end

    let(:delete_category) do
      delete "/api/categories/#{@category2.id}", nil,
        {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it "has a status code of 200" do
      delete_category
      response.response_code.should eql 200
    end

    it "decreases the number of categories" do
      expect { delete_category }.to change { Category.count }.by(-1)
    end

    it "removes the expected category" do
      delete_category
      Category.exists?(@category2.id).should be_false
    end
  end

  context "trying to delete a non-existent category" do
    before :each do
      delete '/api/categories/1', nil,
        {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it "has a status code of 404" do
      response.response_code.should eql 404
    end

    it "has an appropriate error message" do
      error = { error: 'The category you were looking for could not be found' }
      response.body.should eql error.to_json
    end
  end
end
