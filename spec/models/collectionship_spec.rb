require 'spec_helper'

describe Collectionship do
  context "validations" do
    it "is valid with an existing card and category provided" do
      collectionship = build(:collectionship)
      expect(collectionship).to be_valid
    end

    it "is invalid if card_id is missing" do
      collectionship = build(:collectionship, card_id: nil)
      expect(collectionship).to have(1).errors_on(:card_id)
    end

    it "is invalid if collection_id is missing" do
      collectionship = build(:collectionship, collection_id: nil)
      expect(collectionship).to have(1).errors_on(:collection_id)
    end

    it "is invalid if card_id does not correlate to an existing card" do
      collectionship = build(:collectionship, card_id: 1)
      expect(collectionship).to have(1).errors_on(:card_id)
    end

    it "is invalid if collection_id does not correlate to an existing card" do
      collectionship = build(:collectionship, collection_id: 1)
      expect(collectionship).to have(1).errors_on(:collection_id)
    end
  end

  context "trying to insert a duplicate" do
    before :each do
      collectionship = create(:collectionship)
      @dup = build(:collectionship,
                   card_id: collectionship.card_id,
                   collection_id: collectionship.collection_id)
    end

    it "returns one error on :base with an appropriate message" do
      expect(@dup).to have(1).errors_on(:base)
      error = "A link between card_id=#{@dup.card_id} and "\
        "collection_id=#{@dup.collection_id} already exists"
      expect(@dup.errors[:base]).to include error
    end
  end

  context "#updated_since" do
    it "includes collectionships updated after Time.now"
    it "does not include the collectionships updated before Time.now"
    it "includes all cards if no date is provided"
  end
end
