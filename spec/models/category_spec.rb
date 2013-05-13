require 'spec_helper'

describe Category do
  it "is invalid if name is missing" do
    category = build(:category, name: nil)
    expect(category).to have(1).errors_on(:name)
  end

  context "category creation" do
    subject(:category) { build(:category) }

    it "changes the number of categories" do
      expect { category.save }.to change { Category.count }.by(1)
    end

    it { should be_valid }
  end

  context "category destruction with categorizations" do
    let(:categorization) { create(:categorization) }
    let(:destruction) { @category.destroy }

    before :each do
      @category = categorization.category
    end

    it "reduces the number of categorizations by 1" do
      expect { destruction }.to change { Categorization.count }.from(1).to(0)
    end

    it "removes the previously created categorization" do
      expect { destruction }.to change {
        Categorization.exists?(categorization.id)
      }.from(true).to(false)
    end
  end

  describe "#updated_since" do
    before :each do
      @category1 = create(:category)
      @category2 = create(:category)
      @last_updated = Time.now.utc
      @category3 = create(:category)
    end

    it "includes all categories if no date is provided" do
      Category.updated_since(@last_updated).should include(@category3)
    end

    it "includes the categories created after Time.now" do
      Category.updated_since(@last_updated).should_not include(@category1,
                                                               @category2)
    end

    it "does not include cards created before Time.now" do
      Category.updated_since(nil).should include(@category1, @category2, @category3)
    end
  end
end
