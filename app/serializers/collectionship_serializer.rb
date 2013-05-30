class CollectionshipSerializer < ActiveModel::Serializer
  attributes :id, :card_id, :collection_id, :updated_at, :created_at
end
