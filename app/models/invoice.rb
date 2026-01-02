class Invoice < ApplicationRecord
  belongs_to :apartment

  enum :status, { pending: "pending", paid: "paid", overdue: "overdue", partially_paid: "partially_paid" }
end
