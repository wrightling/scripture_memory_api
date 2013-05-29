class Collection < ActiveRecord::Base
  validates :name, presence: true
end
