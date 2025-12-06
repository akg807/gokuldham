class Vendor < ApplicationRecord
  validates_length_of :phone_number, is: 10, message: "must be 10 digits"
end
