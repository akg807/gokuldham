class AddApprovedToVendors < ActiveRecord::Migration[8.1]
  def change
    add_column :vendors, :approved, :boolean, default: false
  end
end
