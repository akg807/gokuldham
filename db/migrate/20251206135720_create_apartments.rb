class CreateApartments < ActiveRecord::Migration[8.1]
  def change
    create_table :apartments do |t|
      t.integer :number, null: false      # Flat number
      t.string  :floor                    # Optional
      t.string  :block, null: false       # Building block (A/B/C…)
      t.string  :amenities_flag, array: true, default: []  # Special PG array

      t.timestamps
    end

    # Ensure one unique apartment per block (no duplicate A-101)
    # add_index :apartments, [:block, :number], unique: true
  end
end
