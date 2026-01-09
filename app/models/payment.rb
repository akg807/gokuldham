class Payment < ApplicationRecord
  belongs_to :invoice

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_id, presence: true
  validates :status, presence: true
end
