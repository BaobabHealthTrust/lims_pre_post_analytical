
class TestController < ApplicationController

	def add_test_handler
		sample_type = params[:sample]
		r_facility = params[:rec_lab]
		dat = SampleOrderController.retrieve_lab_catalog(r_facility)
		test_types = dat["lab_cat"][sample_type]
		@test_types =  test_types - session[:order]['tests']		
	end

	def add_test_loader_handler
		id = "100"
    	url = "localhost:3005/api/patient_lab_trail?npid=#{id}"
		@sample_results = JSON.parse(RestClient.get(url,:contentType => "application/text"))
		 render :layout => false 		
	end


	def add_test_to_sample_loader_handler
		@@trac_number = params[:trac_id]
		sample_type = params[:sample_type]
		tests = eval(params[:tests])
		r_facility = params[:r_facility]
		dat = SampleOrderController.retrieve_lab_catalog(r_facility)
		test_types = dat["lab_cat"][sample_type]
		 if !tests.blank? 
		 	@test_types = test_types - tests
		 else
		 	@test_types = test_types
		 end
	end

	def remove_test_from_order		
		test_name = params[:test_name]
		session[:order]['tests'].delete(test_name)			
	end

	def add_test
		new_test = params[:test]
		new_test.each do |test|
			next if test.empty?
			session[:order]['tests'].push(test)
		end	
		redirect_to   '/confirm_order' 
	end	

	def add_test_to_sample
		order = {
			:_id => @@trac_number,
			:test => params[:test]
		}

		api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
   		api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
    	request = "#{api_url['national_dashboard']}#{api_resources['add_test']}"
    	dat = RestClient.post(request,order)

    	redirect_to '/orders'
	end

end
