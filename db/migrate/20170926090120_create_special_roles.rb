class CreateSpecialRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :special_roles do |t|
      t.string :user_id
      t.string :role_id
      t.string :given_role
      t.timestamps
    end
  end
end
