class User < ApplicationRecord
  has_many :entry_logs, foreign_key: 'rfid'
  has_many :invoices

end