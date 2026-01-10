class AddApartmentToEntryLogs < ActiveRecord::Migration[7.0]
  def up
    add_reference :entry_logs, :apartment, foreign_key: true, index: true, null: true

    # Backfill existing rows (temporary default apartment)
    default_apartment = Apartment.first

    if default_apartment
      execute <<-SQL
        UPDATE entry_logs
        SET apartment_id = #{default_apartment.id}
        WHERE apartment_id IS NULL;
      SQL
    end

    change_column_null :entry_logs, :apartment_id, false
  end

  def down
    remove_reference :entry_logs, :apartment
  end
end
