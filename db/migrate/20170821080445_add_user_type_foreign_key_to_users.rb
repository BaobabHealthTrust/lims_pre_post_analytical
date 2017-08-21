class AddUserTypeForeignKeyToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_reference :users, :user_types, foreign_key: true 
  end
end
