require 'spec_helper'

describe Api::V1::CategoriesController do
  before :all do
    @options = {scope: CategorySerializer, root: "categories"}
  end

  describe "POST #create" do
    before :each do
      post :create, request_payload
    end

    context "with a valid category" do
      let(:request_payload) do
        { categories: [{
            name: 'romans road'
          }]
        }
      end

      it "has a status code of 201" do
        response.response_code.should eql 201
      end

      it "increases the number of categories" do
        Category.count.should eql 1
      end

      it "adds a valid category with expected values" do
        Category.last.name.should eql request_payload[:categories].first[:name]
      end

      it "returns json containing the category" do
        category = Category.last
        json = category.active_model_serializer.new(category, @options).to_json
        expect(response.body).to eql json
      end

      it "includes a location header in the response" do
        category = Category.last
        expect(response.header['Location']).to_not be_nil
        expect(response.header['Location']).to include("/api/categories/#{category.id}")
      end
    end

    context "without a name specified" do
      let(:request_payload) do
        { categories: [{name: nil}] }
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
        @category1 = create(:category)
        @category2 = create(:category)
        @category3 = create(:category)
      end

      let(:delete_category) do
        delete :destroy, id: @category2.id
      end

      it "has a status code of 204" do
        delete_category
        response.response_code.should eql 204
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
        delete :destroy, id: 1
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

  describe "PATCH #update" do
    context "without errors" do
      let(:category1) { create(:category) }

      before :each do
        @request_payload = {
          id: category1.id,
          categories: [{
            name: 'new name'
          }]
        }
      end

      let(:edit_category) { patch :update, @request_payload }

      it "has a status code of 200" do
        edit_category
        response.response_code.should eql 200
      end

      it "has no effect on the number of categories present" do
        expect { edit_category }.not_to change { Category.count }
      end

      it "edits the :name to a new value" do
        expect { edit_category }.to change {
          Category.find(category1.id).name
        }.to(@request_payload[:categories].first[:name])
      end
    end

    context "trying to edit a non-existent category" do
      before :each do
        @request_payload = {
          id: 1,
          categories: [{
            name: 'new name'
          }]
        }

        patch :update, @request_payload
      end

      it { response.response_code.should eql 404 }

      it "has an appropriate error message" do
        error = { error: 'The category you were looking for could not be found' }
        response.body.should eql error.to_json
      end
    end
  end

  describe "GET #index" do
    before :all do
      @options = {scope: CategorySerializer, root: "categories"}
    end

    context "with no date specified" do
      before :each do
        @categories = [create(:category), create(:category)]
        get :index
      end

      it "has a status code of 200" do
        response.response_code.should eql 200
      end

      it "retrieves all categories" do
        json = @categories.active_model_serializer.new(@categories, @options).to_json
        response.body.should eql json
      end
    end

    context "with a date specified" do
      before :each do
        without_timestamping_of(Category) do
          @category1 = create(:old_category)
          @category2 = create(:old_category)
        end
        @last_updated = Time.now.utc
        @category3 = create(:category)

        get :index, last_updated: @last_updated
      end

      it "retrieves the categories updated after Time.now" do
        categories = [@category3]
        json = categories.active_model_serializer.new(categories, @options).to_json
        response.body.should eql json
      end
    end
  end

  describe "GET #show" do
    before :all do
      @options = { scope: CategorySerializer, root: "categories" }
    end

    before :each do
      get :show, id: category.id
    end

    context "when the category is found" do
      let(:category) { create(:category) }

      it "has a status code of 200" do
        expect(response.response_code).to eql 200
      end

      it "returns the requested category" do
        category_array = [category]
        json = category_array.active_model_serializer.new(category_array, @options).to_json
        expect(response.body).to eql json
      end
    end

    context "when the category is not found" do
      let(:category) { double.tap { |dbl| dbl.stub(id: 1) } }

      it "has a status code of 404" do
        expect(response.response_code).to eql 404
      end
    end
  end
end
