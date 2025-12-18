class AddInstanceIdToRequest < ActiveRecord::Migration[8.1]
  def change
    add_column :requests, :instance_id, :integer
  end
end
