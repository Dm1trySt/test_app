class AddApiKeyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :api_key, :string, null: false
    add_column :users, :api_key_expires_at, :datetime, null: false

    add_index :users, :api_key, unique: true
  end
end
