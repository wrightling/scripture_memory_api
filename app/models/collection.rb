class Collection < ActiveRecord::Base
  validates :name, presence: true

  def self.updated_since(time)
    if time
      Collection.where("updated_at >= ?", time)
    else
      Collection.all
    end
  end
end
