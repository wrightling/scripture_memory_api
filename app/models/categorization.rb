class Categorization < ActiveRecord::Base
  attr_accessible :card_id, :category_id

  validates :card_id, presence: true
  validates :category_id, presence: true

  def self.updated_since(time)
    if time
      Categorization.where("updated_at >= ?", time)
    else
      Categorization.all
    end
  end
end
