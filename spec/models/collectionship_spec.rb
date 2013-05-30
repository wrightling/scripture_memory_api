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
    before :all do
      without_timestamping_of(Collectionship) do
        @ship1 = create(:old_collectionship)
        @ship2 = create(:old_collectionship)
      end
      @last_updated = Time.now.utc
      @ship3 = create(:collectionship)
    end

    it "includes collectionships updated after Time.now" do
      Collectionship.updated_since(@last_updated).should include(@ship3)
    end

    it "does not include the collectionships updated before Time.now" do
      Collectionship.updated_since(@last_updated).should_not include(@ship1, @ship2)
    end

    it "includes all cards if no date is provided" do
      Collectionship.updated_since(nil).should include(@ship1, @ship2, @ship3)
    end
  end
end
