class CreateVendors < ActiveRecord::Migration[8.1]
  def change
    create_table :vendors do |t|
      t.string :name, null: false
      t.string :phone_number
      t.uuid   :v_rfid                     # for entry logs
      # t.references :amenity                # vendor type (Electrician = Electrical)

      t.timestamps
    end

    # add_index :vendors, :v_rfid, unique: true
  end
end
