class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      # t.references :user                    # who pays
      # t.references :apartment               # which flat is billed

      t.datetime :due_date
      t.string   :status, default: "pending"   # pending / paid / overdue
      t.datetime :fulfillment_date

      t.integer :paid_amount, default: 0
      t.integer :total_amount, null: false
      t.uuid    :transaction_id              # UPI / bank transfer ID (optional)

      t.timestamps
    end

    # add_index :invoices, :transaction_id, unique: true
  end
end
