require 'spec_helper'

describe Card do
  it "is invalid if scripture is missing" do
    card = Card.new(reference: "John 3:16",
                    subject: "God's Love")
    expect(card).to have(1).errors_on(:scripture)
  end

  it "is invalid if both reference and subject are missing" do
    expect(Card.new(scripture: 'all have sinned')).to be_invalid
  end

  context "card creation" do
    subject(:card) { Card.new(reference: "John 3:16",
                              scripture: "For God so loved..",
                              subject: "God's Love") }

    it "changes the number of cards" do
      expect { card.save }.to change { Card.count }.by(1)
    end

    it { should be_valid }
  end
end
