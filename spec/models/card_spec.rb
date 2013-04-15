require 'spec_helper'

describe Card do
  context "card creation" do
    subject(:card) { Card.new(reference: "John 3:16",
                              scripture: "For God so loved..",
                              subject: "God's Love") }

    it "changes the number of cards" do
      expect { card.save }.to change { Card.count }.by(1)
    end
  end
end
