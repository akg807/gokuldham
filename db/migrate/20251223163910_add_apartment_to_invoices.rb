class AddApartmentToInvoices < ActiveRecord::Migration[8.1]
  def change
    add_reference :invoices, :apartment, null: false, foreign_key: true
  end
end
