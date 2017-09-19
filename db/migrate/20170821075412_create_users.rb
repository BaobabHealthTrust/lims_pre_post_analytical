class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|

      t.string :staff_id     
      t.string :name
      t.string :sex
      t.string :username
      t.string :password
      t.string :email     
      t.string :phoneNumber     
      t.string :user_type_id
      t.timestamps
      
    end
  end

end
