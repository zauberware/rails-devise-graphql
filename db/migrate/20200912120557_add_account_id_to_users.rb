class AddAccountIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :account_id, :uuid
  end
end
