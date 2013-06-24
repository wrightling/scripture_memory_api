require 'spec_helper'

describe Api::V1::CategorizationsController do
  before :all do
    @options = { scope: CategorizationSerializer, root: "categorizations" }
  end

  describe "GET #show" do
    before :each do
      get :show, id: cat.id
    end

    context "when the categorization is found" do
      let(:cat) { create(:categorization) }

      it "has a status of 200" do
        expect(response.response_code).to eql 200
      end

      it "returns the requested categorization" do
        cat_array = [cat]
        json = cat_array.active_model_serializer.new(cat_array, @options).to_json
        expect(response.body).to eql json
      end
    end

    context "when the categorization is not found" do
      let(:cat) { double.tap { |dbl| dbl.stub(id: 1) } }

      it "has a status of 404" do
        expect(response.response_code).to eql 404
      end
    end
  end

  describe "GET #index" do
    context "with no date specified" do
      before :each do
        @cats = [create(:categorization), create(:categorization)]
        get :index
      end

      it "has a status code of 200" do
        response.response_code.should eql 200
      end

      it "retrieves all categorizations" do
        json = @cats.active_model_serializer.new(@cats, @options).to_json
        response.body.should eql json
      end
    end

    context "with a date specified" do
      before :each do
        without_timestamping_of(Categorization) do
          @cat1 = create(:old_categorization)
          @cat2 = create(:old_categorization)
        end
        @last_updated = Time.now.utc
        @cat3 = create(:categorization)

        get :index, last_updated: @last_updated
      end

      it "includes the categorizations updated after Time.now" do
        cats = [@cat3]
        json = cats.active_model_serializer.new(cats, @options).to_json
        response.body.should eql json
      end
    end
  end

  describe "POST #create" do
    before :each do
      post :create, request_payload
    end

    let(:card) { create(:card) }
    let(:category) { create(:category) }

    context "with a valid categorization" do
      subject { response }

      let(:request_payload) do
        { categorizations: [{ card_id: card.id, category_id: category.id }] }
      end

      its(:response_code) { should eql 201 }

      it "increases the number of categorizations by 1" do
        Categorization.count.should eql 1
      end

      it "has expected values after creation" do
        Categorization.last.card_id.should eql card.id
        Categorization.last.category_id.should eql category.id
      end

      it "returns json containing the categorization" do
        categorization = Categorization.last
        json = categorization.active_model_serializer.new(categorization,
                                                          @options).to_json
        expect(response.body).to eql json
      end

      it "includes a location header in the response" do
        categorization = Categorization.last
        expect(response.header['Location']).to_not be_nil
        expect(response.header['Location']).to include("/api/categorizations/#{categorization.id}")
      end
    end

    context "without a valid categorization" do
      subject { response }

      let(:request_payload) do
        { categorizations: [{ card_id: nil, category_id: nil }] }
      end

      its(:response_code) { should eql 422 }
      its(:body) { should include("\"card_id\":[\"can't be blank\"]",
                                  "\"category_id\":[\"can't be blank\"]") }
    end

    context "with a duplicate categorization" do
      let(:request_payload) do
        { categorizations: [{ card_id: card.id, category_id: category.id }] }
      end

      let(:duplicate_post) do
        post :create, request_payload
      end

      it "does not modify the number of categorizations" do
        expect { duplicate_post }.not_to change { Categorization.count }
      end

      it "has a status code of 409" do
        duplicate_post
        expect(response.response_code).to eql 409
      end

      it "returns an appropriate error message" do
        duplicate_post
        expect(response.body).to match /link.*already exists/
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @cat1 = create(:categorization)
      @cat2 = create(:categorization)
      @cat3 = create(:categorization)
    end

    context "without errors" do
      let(:delete_cat) { delete :destroy, id: @cat2.id }

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
        delete :destroy, id: 1
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
end
