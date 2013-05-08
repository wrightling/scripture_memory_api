require 'spec_helper'

describe Card do
  it "is invalid if scripture is missing" do
    expect(build(:card, scripture: nil)).to have(1).errors_on(:scripture)
  end

  it "is invalid if both reference and subject are missing" do
    expect(build(:card, reference: nil, subject: nil)).to have(1).errors_on(:handle)
  end

  context "card creation" do
    subject(:card) { build(:card) }

    it "changes the number of cards" do
      expect { card.save }.to change { Card.count }.by(1)
    end

    it { should be_valid }
  end

  describe "#updated_since" do
    before :each do
      @card1 = create(:card)
      @card2 = create(:card)
      @last_updated = Time.now.utc
      @card3 = create(:card)
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
