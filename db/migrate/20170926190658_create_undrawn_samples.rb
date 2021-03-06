class CreateUndrawnSamples < ActiveRecord::Migration[5.1]
  def change
    create_table :undrawn_samples do |t|
      t.string :tracking_number
      t.string :sample_type
      t.string :patient_id
      t.string :patient_name
      t.string :patient_gender
      t.string :date_of_birth
      t.string :date_requested
      t.string :order_location
      t.string :requested_by
      t.timestamps
    end
  end
end
