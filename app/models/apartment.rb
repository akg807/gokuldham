class Apartment < ApplicationRecord
  has_many :invoices
  has_many :users
end
