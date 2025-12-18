class AddRequestTypeToRequestTable < ActiveRecord::Migration[8.1]
  def change
    add_column :requests, :request_type, :integer, default: 0, null: false
  end
end
