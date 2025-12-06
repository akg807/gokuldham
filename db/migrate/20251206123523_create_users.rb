class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :role, default: "resident"
      t.uuid :r_rfid
      # t.references :apartment  # adds apartment_id
      t.timestamps
    end

    # add_index :users, :email, unique: true
    # add_foreign_key :users, :apartments  # if apartments table exists later
  end
end
