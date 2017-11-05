class PatientController < ApplicationController

	def home_scan_patient_handler	
		session[:current_action] = params[:option]
		if session[:current_action] == "order_test"
			session[:page] = "/sample_ordering"
		elsif session[:current_action] == "view_results"
			session[:page] = "/view_results"
		elsif session[:current_action] == "add_test"
			session[:page] = "/add_test"
		elsif session[:current_action] == "draw_sample"
			session[:page] = "/draw_sample"
		elsif session[:current_action] == "request_order"
			session[:page] = "/request_order"
		elsif session[:current_action] == "add_test_to_order"
			session[:page] = "/orders"
		end
		render :layout => false	
	end

	def scan_patient
		require "dde_resource_provider.rb"

		npid = params[:npid]		
		token = File.read("#{Rails.root}/tmp/token")
		api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    	api_url =  YAML.load_file("#{Rails.root}/config/dde3.yml")[Rails.env]     	
		if token.present?
			obj = Dde.new 
			status = obj.check_token_validity
			
			if status == true 
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
						
						redirect_to session[:page]
					else
						redirect_to "/scan_patient_barcode?option="+session[:current_action]+"&err="+"true"
					end
			elsif status == false || status == nil
				    obj.authenticate_by_new_user
					token = File.read("#{Rails.root}/tmp/token")
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
						
						redirect_to session[:page]
					else
						redirect_to "/scan_patient_barcode?option="+session[:current_action]+"&err="+"true"
					end
			end

		else
			redirect_to "/scan_patient_barcode?option="+session[:current_action]+"&err="+"true"
		end
		
	end

	def tab_search_patient_by_npid_loader
		render :layout => false
	end

	def tab_patient_search_option
		session[:tab_option] = params[:option]

		render :layout => false
	end


	def search_patient_by_id_page_loader_handler

	end

	def search_patient_by_name
		name = params[:name]
		name = name.split(" ")
		gender = params[:gender]
		token = File.read("#{Rails.root}/tmp/token")
		api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    	api_url =  YAML.load_file("#{Rails.root}/config/dde3.yml")[Rails.env]
    	patients = []
    	counter = 0
    	pat = {}
    	if token.present?
		 	request = "#{api_url['dde_url']}#{api_resources['get_patient_by_name']}"
		 	dat = {
			    		"given_name": name[0],
			    		"family_name": name[1],
			    		"gender": gender,
			    		"token": token
			    		}

			res = JSON.parse(RestClient.post(request,dat.to_json, :content_type => 'application/json')) rescue nil
			
			if !res.blank? && res['status'] == 200
				res['data']['hits'].each do |patient|
					details = []
					name = patient['names']['given_name'].to_s+" "+patient['names']['family_name'].to_s
					gender = patient['gender']
					birthdate = patient['birthdate']
					home_district = patient['addresses']['home_district']
					
					details[0] = name
					details[1] = gender
					details[2] = birthdate
					details[3] = home_district
					details[4] = patient['_id']
					patients[counter] = details
					pat[details[4]] = details
					counter = counter + 1
				end
				session[:tab_patients] = pat

				render :json => patients.to_json
			else
				render plain: res.to_json
			end

		else
			render plain: "wronged".to_json
		end
    	
	end

	def tab_search_patient_by_name
		render :layout => false
	end

	def search_patient_by_id
		npid = params[:patient][:npid]
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
				
				redirect_to session[:page]
			else
				redirect_to "/scan_patient_barcode?option="+session[:current_action]+"&err="+"true"
			end

		else
			redirect_to "/scan_patient_barcode?option="+session[:current_action]+"&err="+"true"
		end
	end

end
