class Client < ApplicationRecord
  scope :filter_name, ->(name) { where("name ILIKE ?", "%#{name}%") if name.present? }
  scope :filter_email, ->(email) { where("email ILIKE ?", "%#{email}%") if email.present? }

  has_many :sales
end
