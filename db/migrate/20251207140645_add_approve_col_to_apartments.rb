class AddApproveColToApartments < ActiveRecord::Migration[8.1]
  def change
    add_column :apartments, :approved, :boolean, default: false
  end
end
