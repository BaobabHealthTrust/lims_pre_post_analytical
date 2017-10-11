class PatientController < ApplicationController

	def home_scan_patient_handler
		@@location = ""
		@@option = ""
		@@option = params[:option]
		if @@option == "order_test"
			@@location = "/sample_ordering"
		elsif @@option == "view_results"
			@@location = "/view_results"
		elsif @@option == "add_test"
			@@location = "/add_test"
		elsif @@option == "draw_sample"
			@@location = "/draw_sample"
		elsif @@option == "request_order"
			@@location = "/request_order"
		elsif @@option == "add_test_to_order"
			@@location = "/orders"
		end

		render :layout => false	
	end

	def scan_patient
		npid = params[:npid]		
		token = File.read("#{Rails.root}/tmp/token")
		api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    	api_url =  YAML.load_file("#{Rails.root}/config/dde3.yml")[Rails.env]     	
		if token.present?
		 	request = "#{api_url['dde_url']}#{api_resources['get_patient']}/#{npid}/#{token}"
			res = JSON.parse(RestClient.get(request, :content_type => 'application/json')) rescue nil

			if !res.blank? && res['status'] == 200
				data = res['data']['hits'][0]
				name = data['names']['given_name'].to_s+" "+data['names']['family_name'].to_s
				gender = data['gender']
				address = data['addresses']['home_district']

				patient = {
						"name": name,
						"gender": gender,
						"address": address,
						"npid": npid
				}
				session[:patient_demo] = patient
				
				redirect_to @@location
			else
				redirect_to "/scan_patient_barcode?option="+@@option+"&err="+"true"
			end

		else
			redirect_to "/scan_patient_barcode?option="+@@option+"&err="+"true"
		end
		
	end

end
