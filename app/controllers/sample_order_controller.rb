class SampleOrderController < ApplicationController

	def home
	 
	end

	def capture_order_details
    tests = params[:test]
    tests = tests.delete_if(&:empty?)

		order = {   	
					"district": 'LL',
					"health_facility_name": 'KCH',
					"first_name": "Gift",
          "last_name": "Malolo",
          "middle_name": "M",
          "date_of_birth": "",
          "gender": "",
          "national_patient_id": "100",
					"requesting_clinician": params[:clinician],
					"sample_type": params[:sample_type],
					"tests": tests,
					"date_sample_drawn": "",
					"sample_priority": params[:priority],
					"target_lab": params[:target_lab],
					"reason_for_test": '',					
					"sample_collector_last_name": "",
          "sample_collector_first_name": "",
          "sample_collector_phone_number": '',
          "sample_collector_id": '',
          "sample_order_location": params[:ward],
          "tracking_number": "",
          "art_start_date": "",
          "date_dispatched": "",
          "date_received":  Time.now,
          "return_json": 'true'
				}
		session[:order] = order
		
		redirect_to '/confirm_order'
	end
	
	def confirm_order

	end

	def submite_order
    order = session[:order]
    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
    request = "#{api_url['national-repo-node']}#{api_resources['create_order']}"
    dat = JSON.parse(RestClient.post(request,order))      
    print_tracking_number(dat['tracking_number'])
		session.delete(:order)
	end

  def print_tracking_number(tracking_number)  
      require 'auto12epl.rb'
      auto = Auto12Epl.new
      aligned_lbl =  auto.generate_epl("gift", "malolo", "m","100", "", "30",
                             "m", "","", "",
                             "stat", tracking_number.to_s, tracking_number
      )
   
      send_data(aligned_lbl,
              :type=>"application/label; charset=utf-8",
              :stream=> false,
              :filename=>"#{tracking_number}-#{rand(10000)}.lbl",
              :disposition => "inline"
      )       
  end

	def view_sample_test_results
			@sample_results = { "KCH100003": {
              					"date": "02-02-2017",
              					"sample_type": "blood",
              					"status": "received",
              					"test_done": "4",
              					"test_details":{
              							"Renal Function Test": {
              									"status": "done",
              									"results": {
              											"Bilurubin": "20",
              											"Culture": "Growth"
              										}
              								},
              							"Preg Test": {
              									"status": "done",
              									"results": {
              											"Progestrone": "20"              											
              										}
              								},
              							"Renal Function Tests": {
              									"status": "done",
              									"results": {
              											"Bilurubin": "20",
              											"Culture": "Growth"
              										}
              								},
              							"Renal Function Testss": {
              									"status": "done",
              									"results": {
              											"Bilurubin": "20",
              											"Culture": "Growth"
              										}
              								}
              						}
            			},
            			"KCH100004": {
              					"date": "03-02-2017",
              					"sample_type": "blood",
              					"status": "received",
              					"test_done": "4",
              					"test_details":{
              							"Renal Function Test": {
              									"status": "done",
              									"results": {
              											"Bilurubin": "20",
              											"Culture": "Growth"
              										}
              								},
              							"Preg Test": {
              									"status": "done",
              									"results": {
              											"Progestrone": "20"              											
              										}
              								}
              						}
            			},
            			"KCH100005": {
              					"date": "03-02-2017",
              					"sample_type": "blood",
              					"status": "received",
              					"test_done": "4",
              					"test_details":{
              							"Renal Function Test": {
              									"status": "done",
              									"results": {
              											"Bilurubin": "20",
              											"Culture": "Growth"
              										}
              								},
              							"Preg Test": {
              									"status": "done",
              									"results": {
              											"Progestrone": "20"              											
              										}
              								}
              						}
            			},
            			"KCH100006": {
              					"date": "03-02-2017",
              					"sample_type": "blood",
              					"status": "received",
              					"test_done": "4",
              					"test_details":{
              							"Renal Function Test": {
              									"status": "done",
              									"results": {
              											"Bilurubin": "20",
              											"Culture": "Growth"
              										}
              								},
              							"Preg Test": {
              									"status": "done",
              									"results": {
              											"Progestrone": "20"              											
              										}
              								}
              						}
            			}
			}

			session[:results] = @sample_results
	
	end

	def view_individual_sample_test_results
		results = session[:results]
		id = params[:id].split('_')[1]
		@test_results = results[id]['test_details']
		
	end
	
	def view_sample_to_add_new_test_handler

	end

	def view_sample_test_handler

	end

	def draw_sample_handler

	end
	

end













