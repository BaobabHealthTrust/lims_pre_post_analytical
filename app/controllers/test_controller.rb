
class TestController < ApplicationController

	def add_test_handler
		sample_type = params[:sample]
		r_facility = params[:rec_lab]
		dat = SampleOrderController.retrieve_lab_catalog(r_facility)
		test_types = dat["tests"][sample_type]
		@test_types =  test_types - session[:order]['tests']		
	end

	def add_test_loader_handler
		id = session[:patient_demo]['npid']
    	url = "localhost:3005/api/patient_lab_trail?npid=#{id}"
		@sample_results = JSON.parse(RestClient.get(url,:contentType => "application/text"))
	    render :layout => false 		
	end

	def tab_select_test
		details = []
		sample_type = params[:sample]
		r_facility = params[:rec_lab]
		details[0] = sample_type
		details[1] = r_facility
		session[:lab_sample] = details
		dat = SampleOrderController.retrieve_lab_catalog(r_facility)
		@test_types = dat["lab_cat"][sample_type]
		
		render :layout => false
	end


	def add_test_to_sample_loader_handler
		@@trac_number = params[:trac_id]
		sample_type = params[:sample_type]
		tests = eval(params[:tests])
		r_facility = params[:r_facility]
		dat = SampleOrderController.retrieve_lab_catalog(r_facility)
		test_types = dat["tests"][sample_type]
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
		tests = params[:test]
		api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
		lab = session[:target_lab] 
	    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
	    request = "#{api_url['national_dashboard']}#{api_resources['retrieve_lab_catalog']}?lab="+lab
	    cat = JSON.parse(RestClient.post(request,""))  
	    pan_test = cat['test_panels']
	    panels = cat['test_panels'].keys
	    session.delete('lab')

	     inde = tests.index("MC&amp;S")
		    if !inde.blank?
		      tests.delete_at(inde)
		      tests.push("MC&S")
		    end

		    ind = tests.index("Manual Differential &amp; Cell Morphology")
		    
		    if !ind.blank?
		      tests.delete_at(ind)
		      tests.push("Manual Differential & Cell Morphology")
		    end
    
	    tests.each do |test|
			next if tests.empty?
			session[:order]['tests'].push(test)
		end	

	    if tests.include?("MC&S") && tests.include?("CSF Analysis")
	      	
	        panels.each do |panel|
	          next if panel == "MC&S"
	          if tests.include?(panel)
	              pan_test[panel].each do |tst|
	              session[:order]['tests'].push(tst)
	            end           
	          end
	        end
	    else
	        panels.each do |panel|
	          if tests.include?(panel)
	              pan_test[panel].each do |tst|
	              session[:order]['tests'].push(tst)
	            end
	          end
	        end
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

    	redirect_to '/orders?added=' + 'yes'
	end

end
