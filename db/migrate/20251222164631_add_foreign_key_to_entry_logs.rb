class AddForeignKeyToEntryLogs < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :entry_logs, :users,
                    column: :rfid,
                    primary_key: :r_rfid
  end
end
