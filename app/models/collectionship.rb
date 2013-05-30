class Collectionship < ActiveRecord::Base
  belongs_to :card
  belongs_to :collection

  validates :card_id, presence: true
  validates :collection_id, presence: true

  validate :references_an_existing_card, unless: "card_id.nil?"
  validate :references_an_existing_collection, unless: "collection_id.nil?"
  validate :unique_card_collection_combination,
    unless: "card_id.nil? or collection_id.nil?"

  def self.updated_since(time)
    if time
      Collectionship.where("updated_at >= ?", time)
    else
      Collectionship.all
    end
  end

  private

  def references_an_existing_card
    if !Card.exists?(card_id)
      errors[:card_id] << "The associated Card does not exist"
    end
  end

  def references_an_existing_collection
    if !Collection.exists?(collection_id)
      errors[:collection_id] << "The associated Collection does not exist"
    end
  end

  def unique_card_collection_combination
    if Collectionship.where("card_id=? and collection_id=?", card_id, collection_id).any?
      errors[:base] << "A link between card_id=#{card_id} and "\
        "collection_id=#{collection_id} already exists"
    end
  end
end
