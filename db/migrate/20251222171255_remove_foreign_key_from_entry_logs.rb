class RemoveForeignKeyFromEntryLogs < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :entry_logs, name: "fk_rails_6787f6f2c3"
  end
end
