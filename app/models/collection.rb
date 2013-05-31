class Collection < ActiveRecord::Base
  has_many :collectionships, dependent: :destroy
  has_many :cards, through: :collectionships

  validates :name, presence: true

  def self.updated_since(time)
    if time
      Collection.where("updated_at >= ?", time)
    else
      Collection.all
    end
  end
end
