class CreatePayments < ActiveRecord::Migration[8.1]
  def change
  create_table :payments do |t|
    t.references :invoice, null: false, foreign_key: true
    t.decimal :amount, precision: 10, scale: 2, null: false
    t.string :transaction_id, null: false
    t.string :status, null: false
    t.datetime :paid_at, null: false
    t.timestamps
    end
  end
end
