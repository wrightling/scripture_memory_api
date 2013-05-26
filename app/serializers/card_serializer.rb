class CardSerializer < ActiveModel::Serializer
  attributes :id, :subject, :reference, :scripture, :translation, :created_at, :updated_at
end
