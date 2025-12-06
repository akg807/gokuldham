class CreateEntryLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :entry_logs do |t|
      t.uuid :rfid, null: false                 # RFID tag from User or Vendor
      t.datetime :in_time
      t.datetime :out_time
      # t.references :apartment                   # Which flat the person belongs to

      t.timestamps
    end

    # add_index :entry_logs, :rfid
  end
end
