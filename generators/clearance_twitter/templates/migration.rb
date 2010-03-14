class AddClearanceTwitterFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_username, :string
    add_column :users, :twitter_id, :string
    add_column :users, :twitter_access_token, :string
    add_column :users, :twitter_access_secret, :string
  end

  def self.down
    remove_column :users, :twitter_access_token
    remove_column :users, :twitter_access_secret
    remove_column :users, :twitter_id
    remove_column :users, :twitter_username
  end
end
