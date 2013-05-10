class CategorizationSerializer < ActiveModel::Serializer
  attributes :id, :card_id, :category_id, :updated_at, :created_at
end
