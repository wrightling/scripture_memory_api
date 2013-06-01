require 'spec_helper'

describe CollectionSerializer do
  before :all do
    @options = { scope: CollectionSerializer, root: "collections" }
  end

  let(:collection) { create(:collection) }

  let(:collection_json_example) do
    { "collections" => [{
      id: collection.id,
      name: collection.name,
      created_at: collection.created_at,
      updated_at: collection.updated_at }]
    }
  end

  let(:json) do
    array = [collection]
    array.active_model_serializer.new(array, @options).as_json
  end

  it "returns properly formatted json for a single collection" do
    expect(json).to eql collection_json_example
  end
end

