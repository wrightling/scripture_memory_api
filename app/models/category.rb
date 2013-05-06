class Category < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true

  def self.updated_since(time)
    if time
      Category.where("updated_at >= ?", time)
    else
      Category.all
    end
  end
end
