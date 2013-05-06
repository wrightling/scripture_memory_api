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
      @category1 = FactoryGirl.create(:category)
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
    it "has a status code of 404"
    it "has an appropriate error message"
  end
end
