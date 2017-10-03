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
					"requesting_clinician": params[:clinician][:name],
					"sample_type": params[:sample_type],
					"tests": tests,
					"date_sample_drawn": Time.now,
					"sample_priority": params[:priority],
					"target_lab": params[:target_lab],
					"reason_for_test": params[:priority],					
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
		
		return redirect_to '/confirm_order'

	end
	
  def capture_order_request_details
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
          "requesting_clinician": "",
          "sample_type": params[:sample_type],
          "tests": tests,
          "date_sample_drawn": Time.now,
          "sample_priority": params[:priority],
          "target_lab": params[:target_lab],
          "reason_for_test": params[:priority],         
          "sample_collector_last_name": "",
          "sample_collector_first_name": "",
          "sample_collector_phone_number": '',
          "sample_collector_id": '',
          "sample_order_location": params[:ward],
          "tracking_number": "",
          "status": "not drawn",
          "art_start_date": "",
          "date_dispatched": "",
          "date_received":  Time.now,             
          "return_json": 'true'
        }

   submite_order_request(order)
   redirect_to '/scan_patient_barcode?option='+'request_order', flash: {:error => "order request done successfuly"}
  
  end
  

	def confirm_order
    @order = session[:order]
    render :layout => false 
	end

	def submite_order
    order = session[:order]
    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
    request = "#{api_url['national-repo-node']}#{api_resources['create_order']}"
    dat = JSON.parse(RestClient.post(request,order))      
    print_tracking_number(dat['tracking_number'])

    p_name = order['first_name'].to_s + " " +  order['middle_name'] +" "+order['last_name'].to_s
    UndispatchedSample.capture_sample(dat['tracking_number'],order['sample_type'],order['national_patient_id'],
                                  p_name,order['date_sample_drawn'],order['gender'],order['target_lab'],session[:ward])

    
		session.delete(:order)
  
	end

  def submite_order_request(order_requested)
    order = order_requested
    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
    request = "#{api_url['national-repo-node']}#{api_resources['create_order']}"
    dat = JSON.parse(RestClient.post(request,order))
    session.delete(:requested_order)
  end

  def self.retrieve_lab_catalog(lab)     
      api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
      api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
      request = "#{api_url['national_dashboard']}#{api_resources['retrieve_lab_catalog']}?lab="+lab
      @@dat = JSON.parse(RestClient.post(request,""))    
      return @@dat
  end

  def get_samples
      lab = params[:lab]
      cat =  SampleOrderController.retrieve_lab_catalog(lab) 
      render plain: cat["samples"].collect{|l| "<li>"+ l}.join("<li>")+"</li>"
  end

  def get_test_types
     sample = params[:sample_name]
     test_types = @@dat['lab_cat'][sample]
     render plain: test_types.collect{|l| "<li>" + l}.join("<li>")+ "</li>"
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
    id = "100"
    url = "localhost:3005/api/patient_lab_trail?npid=#{id}"

    @sample_results = JSON.parse(RestClient.get(url,:contentType => "application/text"))
    @@sample_results_glo =  @sample_results
	  render :layout => false 
	end

	def view_individual_sample_test_results
  	results = @@sample_results_glo
		@id = params[:id].split('_')[1]
    result_measuers = {} 
    details = []
    @test_status = {}
    results.each do |rst|
        next if rst['_id'] != @id
        @test_types = rst['results'].keys

        @test_types.each do |test|

          if rst['results'][test].length < 5

            result_measuers[test] = {"measure_name" => "null","result" => "null"}
            @test_status[test] = "not available"
          elsif rst['results'][test].length >= 5
            results = rst['results'][test].keys
            results = results[4]
            
            rst['results'][test][results]['results'].each do |s|

              details.push({"measure_name" => s[0],"result" => s[1]})
              
            end
          result_measuers[test] = details
          session[:rs] =  result_measuers[test]
          @test_status[test] = "available"
          details = []
          end           
        end
        render :layout => false 
    end
      
	end

  def get_result_measures
    test_type = params[:type]
    measures = session[:rs]
    render :json => measures.to_json    
  end
	
	def view_sample_to_add_new_test_handler

	end

	def view_sample_test_handler

	end

	def draw_sample_handler

	end

  def draw_sample
    
  end
	
  def order_request_page_loader_handler

  end


end













