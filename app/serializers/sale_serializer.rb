class SaleSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :client
  belongs_to :toy
end
