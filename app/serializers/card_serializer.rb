class CardSerializer < ActiveModel::Serializer
  attributes :created_at, :id, :subject, :scripture, :reference, :updated_at
end
