require 'spec_helper'

describe Categorization do
  context "validations" do
    it "is valid with an existing card and category provided" do
      categorization = build(:categorization)
      expect(categorization).to be_valid
    end

    it "is invalid if card_id is missing" do
      categorization = build(:categorization, card_id: nil)
      expect(categorization).to have(1).errors_on(:card_id)
    end

    it "is invalid if category_id is missing" do
      categorization = build(:categorization, category_id: nil)
      expect(categorization).to have(1).errors_on(:category_id)
    end

    it "is invalid if card_id does not correlate to an existing card" do
      categorization = build(:categorization, card_id: 1)
      expect(categorization).to have(1).errors_on(:card_id)
    end

    it "is invalid if category_id does not correlate to an existing category" do
      categorization = build(:categorization, category_id: 1)
      expect(categorization).to have(1).errors_on(:category_id)
    end
  end

  context "trying to insert a duplicate" do
    before :each do
      categorization = create(:categorization)
      @duplicate = build(:categorization,
                         card_id: categorization.card_id,
                         category_id: categorization.category_id)
    end

    it "returns one error on :base with an appropriate message" do
      expect(@duplicate).to have(1).errors_on(:base)
      error = "A link between card_id=#{@duplicate.card_id} and "\
        "category_id=#{@duplicate.category_id} already exists"
      expect(@duplicate.errors[:base]).to include error
    end
  end

  describe "#updated_since" do
    before :each do
      @cat1 = create(:categorization)
      @cat2 = create(:categorization)
      @last_updated = Time.now.utc
      @cat3 = create(:categorization)
    end

    it "includes the categorizations created after Time.now" do
      Categorization.updated_since(@last_updated).should include(@cat3)
    end

    it "does not inlude categorizations created before Time.now" do
      Categorization.updated_since(@last_updated).should_not include(@cat1, @cat2)
    end

    it "includes all cards if no date is provided" do
      Categorization.updated_since(nil).should include(@cat1, @cat2, @cat3)
    end
  end
end
