class Vendor < ApplicationRecord
  validates_length_of :phone_number, is: 10, message: "must be 10 digits"
  has_many :entry_logs,
          ->(vendor) { where(rfid: vendor.v_rfid) },
           class_name: "EntryLog",
           foreign_key: :rfid,
           primary_key: :v_rfid
end
