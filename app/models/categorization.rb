class Categorization < ActiveRecord::Base
  belongs_to :card
  belongs_to :category

  validates :card_id, presence: true
  validates :category_id, presence: true

  validate :unique_card_category_combination,
    unless: "card_id.nil? or category_id.nil?"
  validate :references_an_existing_card, unless: "card_id.nil?"
  validate :references_an_existing_category, unless: "category_id.nil?"

  def self.updated_since(time)
    if time
      Categorization.where("updated_at >= ?", time)
    else
      Categorization.all
    end
  end

  private

  def references_an_existing_card
    if !Card.exists?(card_id)
      errors[:card_id] << "The associated Card does not exist"
    end
  end

  def references_an_existing_category
    if !Category.exists?(category_id)
      errors[:category_id] << "The associated Category does not exist"
    end
  end

  def unique_card_category_combination
    if Categorization.where("card_id=? and category_id=?", card_id, category_id).any?
      errors[:base] << "A link between card_id=#{card_id} and "\
        "category_id=#{category_id} already exists"
    end
  end
end
