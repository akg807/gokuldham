class AddApartmentIdToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :apartment, foreign_key: true
  end
end
