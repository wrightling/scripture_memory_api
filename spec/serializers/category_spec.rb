require 'spec_helper'

describe CategorySerializer do
  before :all do
    @options = { scope: CategorySerializer, root: "categories" }
  end

  let(:category) { create(:category) }

  let(:category_json_example) do
    { "categories" => [{
      id: category.id,
      name: category.name,
      created_at: category.created_at,
      updated_at: category.updated_at }]
    }
  end

  let(:json) do
    array = [category]
    array.active_model_serializer.new(array, @options).as_json
  end

  it "returns properly formatted json for a single category" do
    expect(json).to eql category_json_example
  end
end
