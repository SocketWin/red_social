class AddLoginSexImageToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :login, :string
	add_column :users, :sex, :string
	add_column :users, :image, :string
	rename_column :users, :pass, :password_digest
	add_index :users, :login, unique: true
  end
end
