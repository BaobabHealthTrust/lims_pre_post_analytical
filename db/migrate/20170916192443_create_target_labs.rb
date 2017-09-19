class CreateTargetLabs < ActiveRecord::Migration[5.1]
  def change
    create_table :target_labs do |t|
      t.string :name
      t.string :district_id
      t.string :phone_number
      t.timestamps
      
    end
  end
end
