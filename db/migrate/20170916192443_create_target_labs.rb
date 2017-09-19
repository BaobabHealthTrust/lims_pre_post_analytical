class CreateTargetLabs < ActiveRecord::Migration[5.1]
  def change
    create_table :target_labs do |t|

      t.timestamps
    end
  end
end
