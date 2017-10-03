class UndispatchedSample < ApplicationRecord

   def self.capture_sample(tracking_number,sample_type,patient_id,patient_name,date_drawn,sex,lab,ward)
   		row = UndispatchedSample.new
   		row.tracking_number = tracking_number
   		row.date_drawn = date_drawn
   		row.patient_id = patient_id
   		row.patient_name = patient_name
   		row.sex = sex
   		row.sample_type = sample_type
   		row.target_lab = lab
         row.order_location = ward
   		row.save()
   end

   def self.retrive_undispatched_samples(lab,location)
   		row = UndispatchedSample.find_by_sql("SELECT * FROM undispatched_samples WHERE target_lab='#{lab}' AND order_location='#{location}'")
 
   		if (!row.blank?)
   			return row
   		end
   end

   def self.count_undispatched_samples(location)
   		row = UndispatchedSample.find_by_sql("SELECT count(*) AS UndispatchedSample FROM undispatched_samples WHERE order_location='#{location}'")   		
   		if (!row.blank?)
   			return row[0].UndispatchedSample
   		end
   end

   def self.count_undispatched_samples_by_target_lab(location)
   		row = UndispatchedSample.find_by_sql("SELECT count(*) AS total,
   									 undispatched_samples.target_lab AS lab FROM undispatched_samples WHERE order_location='#{location}'
												GROUP BY undispatched_samples.target_lab")   	
		
   		if (!row.blank?)
   			return row
   		end
   end

   def self.remove_dispatched_sample(tracking_number)
         row = UndispatchedSample.find_by(:tracking_number => tracking_number)
         row.destroy()
   end

end
