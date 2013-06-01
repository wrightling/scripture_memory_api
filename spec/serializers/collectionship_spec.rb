require 'spec_helper'

describe CollectionshipSerializer do
  before :all do
    @options = { scope: CollectionshipSerializer, root: "collectionships" }
  end

  let(:ship) { create(:collectionship) }

  let(:ship_json_example) do
    { "collectionships" => [{
      id: ship.id,
      card_id: ship.card.id,
      collection_id: ship.collection.id,
      created_at: ship.created_at,
      updated_at: ship.updated_at }]
    }
  end

  let(:json) do
    array = [ship]
    array.active_model_serializer.new(array, @options).as_json
  end

  it "returns properly formatted json for a single collectionship" do
    expect(json).to eql ship_json_example
  end
end

