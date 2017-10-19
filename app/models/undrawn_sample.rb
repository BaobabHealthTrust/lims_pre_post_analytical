class UndrawnSample < ApplicationRecord

	
	def self.capture_order_request(requested_order,track_number)
		order = UndrawnSample.new
		order.tracking_number = track_number
		order.sample_type = requested_order[:sample_type]
		order.patient_id = requested_order[:national_patient_id]
		order.patient_name = requested_order[:first_name].to_s+" "+requested_order[:last_name].to_s
		order.patient_gender = requested_order[:gender]
		order.date_of_birth = requested_order[:date_of_birth]
		order.date_requested = Time.now().strftime("%Y%m%d%H%M%S")
		order.order_location = requested_order[:sample_order_location]
		order.requested_by = requested_order[:requesting_clinician]
		order.save()

	end


	def self.count_requested_samples(location)
		count = UndrawnSample.find_by_sql("SELECT count(*) AS requested_samples FROM undrawn_samples WHERE order_location='#{location}'")
		if !count.blank?
			return count[0].requested_samples
		end
	end

	def self.retrieve_requested_samples(location)
		samples = UndrawnSample.find_by_sql("SELECT * FROM undrawn_samples WHERE order_location='#{location}'")
		if !samples.blank?
			return samples
		end

	end

	def self.remove_sampl(tracking_number)
		row = UndrawnSample.find_by(:tracking_number => tracking_number)
		row.destroy()
	end

	def self.retrive_undrawn_sample(number)

		sample = UndrawnSample.find_by_sql("SELECT * FROM undrawn_samples WHERE tracking_number='#{number}'")
		if !sample.blank?
			return sample
		end
	
	end


end
