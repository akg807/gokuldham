class CreateRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :requests do |t|
      t.string :reference_number, null: false
      t.string :description, null: false
      t.string :status, null: false, default: "pending"   # pending / in_progress / done
      t.datetime :eta                                       # Estimated time to complete

      # t.references :apartment                               # optional link to flat
      # t.references :vendor                                  # who will resolve

      t.timestamps
    end

    # add_index :requests, :reference_number, unique: true
  end
end
