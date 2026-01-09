class AddUniqueIndexToUsersRrfid < ActiveRecord::Migration[8.1]
  def change
    add_index :users, :r_rfid, unique: true
  end
end
# fk_rails_6787f6f2c3