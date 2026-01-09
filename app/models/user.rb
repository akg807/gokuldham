class User < ApplicationRecord
  has_many :entry_logs,
           ->(user) { where(rfid: user.r_rfid) },
           class_name: "EntryLog",
           foreign_key: :rfid,
           primary_key: :r_rfid

  has_many :invoices
end
