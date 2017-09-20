class CreateUserTypeRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_type_roles do |t|
      t.string :user_type_id
      t.string :role_id
      t.string :given_role
      t.timestamps
    end
  end
end
