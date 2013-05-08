require 'spec_helper'

describe "EditCategories" do
  before :each do
    @request_payload = {
      category: {
        name: 'new name'
      }
    }
  end

  context "without errors" do
    before :each do
      @category1 = create(:category)
    end

    let(:edit_category) { put "/api/categories/#{@category1.id}",
                            @request_payload,
                            {"HTTP_ACCEPT" => "application/smapi.v1"}}

    it "has a status code of 200" do
      edit_category
      response.response_code.should eql 200
    end

    it "has no effect on the number of categories present" do
      expect { edit_category }.not_to change { Category.count }
    end

    it "edits the :name to a new value" do
      expect { edit_category }.to change {
        Category.find(@category1.id).name
      }.to(@request_payload[:category][:name])
    end
  end

  context "trying to edit a non-existent category" do
    before :each do
      put '/api/categories/1',
        @request_payload,
        {'HTTP_ACCEPT' => 'application/smapi.v1'}
    end

    it { response.response_code.should eql 404 }

    it "has an appropriate error message" do
      error = { error: 'The category you were looking for could not be found' }
      response.body.should eql error.to_json
    end
  end
end
