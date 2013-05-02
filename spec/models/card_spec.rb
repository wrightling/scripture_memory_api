require 'spec_helper'

describe Card do
  it "is invalid if scripture is missing" do
    card = Card.new(reference: "John 3:16",
                    subject: "God's Love")
    expect(card).to have(1).errors_on(:scripture)
  end

  it "is invalid if both reference and subject are missing" do
    expect(Card.new(scripture: 'all have sinned')).to have(1).errors_on(:base)
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

  describe "#updated_since" do
    before :each do
      @card1 = Card.create(reference: 'Rom 3:23', scripture: 'all have sinned')
      @card2 = Card.create(reference: 'Rom 6:23', scripture: 'the wages of sin...')
      @last_updated = Time.now
      @card3 = Card.create(reference: 'Rom 12:1', scripture: 'Therefore we urge..')
    end

    it "includes the cards created after Time.now" do
      Card.updated_since(@last_updated).should include(@card3)
    end

    it "does not include cards created before Time.now" do
      Card.updated_since(@last_updated).should_not include(@card1,
                                                                 @card2)
    end

    it "includes all cards if no date is provided" do
      Card.updated_since(nil).should include(@card1, @card2, @card3)
    end
  end
end
