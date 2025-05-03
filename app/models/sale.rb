class Sale < ApplicationRecord
  belongs_to :toy
  belongs_to :client
end