require 'spec_helper'

describe Collection do
  it "is invalid if name is missing" do
    collection = build(:collection, name: nil)
    expect(collection).to have(1).errors_on(:name)
  end

  context "collection creation" do
    subject(:collection) { build(:collection) }

    it "changes the number of collections" do
      expect { collection.save }.to change { Collection.count }.by(1)
    end

    it { should be_valid }
  end

  context "destruction with collections" do
    let(:collectionship) { create(:collectionship) }
    let(:destruction) { @collection.destroy }

    before :each do
      @collection = collectionship.collection
    end

    it "reduces the number of collectionships by 1" do
      expect { destruction }.to change { Collectionship.count }.from(1).to(0)
    end

    it "removes the previously created collectionship" do
      expect { destruction }.to change {
        Collectionship.exists?(collectionship.id)
      }.from("1").to(nil)
    end
  end

  describe "#updated_since" do
    before :each do
      @collection1 = create(:collection)
      @collection2 = create(:collection)
      @last_updated = Time.now.utc
      @collection3 = create(:collection)
    end

    it "includes all collections if no date is provided" do
      Collection.updated_since(@last_updated).should include(@collection3)
    end

    it "includes the collections created after Time.now" do
      Collection.updated_since(@last_updated).should_not include(@collection1,
                                                               @collection2)
    end

    it "does not include collections created before Time.now" do
      Collection.updated_since(nil).should include(@collection1, @collection2, @collection3)
    end
  end
end
