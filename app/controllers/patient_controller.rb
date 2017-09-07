class PatientController < ApplicationController

	def home_scan_patient_handler
		option = params[:option]
		if option == "order_test"
			@location = "/sample_ordering"
		elsif option == "view_results"
			@location = "/view_results"
		elsif option == "add_test"
			@location = "/add_test"
		elsif option == "draw_sample"
			@location = "/draw_sample"
		end
	end
end
