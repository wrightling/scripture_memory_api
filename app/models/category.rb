class Category < ActiveRecord::Base
  has_many :categorizations, dependent: :destroy
  has_many :cards, through: :categorizations

  validates :name, presence: true

  def self.updated_since(time)
    if time
      Category.where("updated_at >= ?", time)
    else
      Category.all
    end
  end
end
