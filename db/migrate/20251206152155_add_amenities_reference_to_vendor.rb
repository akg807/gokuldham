class AddAmenitiesReferenceToVendor < ActiveRecord::Migration[8.1]
  def change
    add_reference :vendors, :amenity
    add_foreign_key :vendors, :amenities
  end
end
