require 'spec_helper'

describe CardSerializer do
  before :all do
    @options = { scope: CardSerializer, root: "cards" }
  end

  let(:card) { create(:card) }

  let(:card_json_example) do
    { "cards" => [{
      id: card.id,
      subject: card.subject,
      reference: card.reference,
      scripture: card.scripture,
      translation: card.translation,
      created_at: card.created_at,
      updated_at: card.updated_at }]
    }
  end

  let(:json) do
    array = [card]
    array.active_model_serializer.new(array, @options).as_json
  end

  it "returns properly formatted json for a single Card" do
    expect(json).to eql card_json_example
  end
end
