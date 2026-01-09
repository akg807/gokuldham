class AddPenaltyToInvoices < ActiveRecord::Migration[8.1]
  def change
  add_column :invoices, :penalty_amount, :decimal, default: 0
  add_column :invoices, :penalty_applied, :boolean, default: false
  end
end
