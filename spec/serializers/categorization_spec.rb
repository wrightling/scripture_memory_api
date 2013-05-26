require 'spec_helper'

describe CategorizationSerializer do
  before :all do
    @options = { scope: CategorizationSerializer, root: "categorizations" }
  end

  let(:cat) { create(:categorization) }

  let(:cat_json_example) do
    { "categorizations" => [{
      id: cat.id,
      card_id: cat.card.id,
      category_id: cat.category.id,
      created_at: cat.created_at,
      updated_at: cat.updated_at }]
    }
  end

  let(:json) do
    array = [cat]
    array.active_model_serializer.new(array, @options).as_json
  end

  it "returns properly formatted json for a single categorization" do
    expect(json).to eql cat_json_example
  end
end
