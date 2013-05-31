class Card < ActiveRecord::Base
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  has_many :collectionships, dependent: :destroy
  has_many :collections, through: :collectionships

  validates :scripture, presence: true
  validate :at_least_one_subject_or_reference

  def self.updated_since(time)
    if time
      Card.where("updated_at >= ?", time)
    else
      Card.all
    end
  end

  private

  def at_least_one_subject_or_reference
    if String(subject).empty? && String(reference).empty?
      errors[:base] << "Please include a reference or subject"
    end
  end
end
