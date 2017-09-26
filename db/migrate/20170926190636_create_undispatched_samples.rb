class CreateUndispatchedSamples < ActiveRecord::Migration[5.1]
  def change
    create_table :undispatched_samples do |t|
      t.string :tracking_number
      t.string :date_drawn
      t.string :patient_id
      t.string :patient_name
      t.string :sex
      t.string :sample_type
      t.timestamps
    end
  end
end
