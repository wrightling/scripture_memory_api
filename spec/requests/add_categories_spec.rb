require 'spec_helper'

describe "AddCategories" do
  before :each do
    post '/api/categories', request_payload,
      {'HTTP_ACCEPT' => 'application/smapi.v1'}
  end

  context "with a valid category" do
    let(:request_payload) do
      { category: {
          name: 'romans road'
        }
      }
    end

    it "has a status code of 201" do
      response.response_code.should eql 201
    end

    it "increases the number of categories" do
      Category.count.should eql 1
    end

    it "adds a valid category with expected values" do
      Category.last.name.should eql request_payload[:category][:name]
    end
  end

  context "without a name specified" do
    let(:request_payload) do
      { category: {} }
    end

    it "has a status code of 422" do
      response.response_code.should eql 422
    end

    it "returns an appropriate error message" do
      response.body.should include "Name can't be blank" 
    end
  end
end
