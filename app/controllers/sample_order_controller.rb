class SampleOrderController < ApplicationController

	def home
	   
	end

	def capture_order_details
    tests = params[:test]
    tests = tests.delete_if(&:empty?)
    patient = session[:patient_demo]
    patient_name = patient['name'].split(" ")

    curnt_user = User.search_user_by_id(session[:user])
    if !curnt_user.blank?
       requesting_clinician =  curnt_user[0]['username']
    end
    config = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]
    district =  config['district']
    who_order_test = params[:clinician][:name].split(" ")
    if who_order_test.length > 1
      first_name = who_order_test[0]
      last_name = who_order_test[1]
    elsif  who_order_test.length == 1
      first_name = who_order_test[0]
    end

		order = {   	
					"district": district,
					"health_facility_name": config['facility_name'],
					"first_name": patient_name[0],
          "last_name": patient_name[1],
          "middle_name": " ",
          "date_of_birth": patient["birthdate"] || nil,
          "gender": patient['gender'],
          "national_patient_id": patient['npid'],
					"requesting_clinician": params[:clinician][:name],
					"sample_type": params[:sample_type],
					"tests": tests,
					"date_sample_drawn": Time.now.strftime("%Y%m%d%H%M%S"),
					"sample_priority": params[:priority],
					"target_lab": params[:target_lab],
					"reason_for_test": params[:priority],					
					"sample_collector_last_name": first_name || nil,
          "sample_collector_first_name": last_name || nil,
          "sample_collector_phone_number": '',
          "sample_collector_id": '',
          "sample_order_location": session[:ward],
          "tracking_number": "",
          "art_start_date": "",
          "date_dispatched": "",
          "date_received":  "",             
          "return_json": 'true'
				}

		session[:order] = order
		
		return redirect_to '/confirm_order'

	end
	
  def capture_order_request_details
    tests = params[:test]
    tests = tests.delete_if(&:empty?)
    patient = session[:patient_demo]
    patient_name = patient['name'].split(" ")

    curnt_user = User.search_user_by_id(session[:user])
    if !curnt_user.blank?
       requesting_clinician =  curnt_user[0]['name']
    end
    config = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]
    district =  config['district']
        
     who_order_test = requesting_clinician.split(" ")
    if who_order_test.length > 1
      first_name = who_order_test[0]
      last_name = who_order_test[1]
    elsif  who_order_test.length == 1
      first_name = who_order_test[0]
    end
    order = {     
          "district": district,
          "health_facility_name": config['facility_name'],
          "first_name": patient_name[0],
          "last_name": patient_name[1],
          "middle_name": " ",
          "date_of_birth": patient["birthdate"] || nil,
          "gender": patient['gender'],
          "national_patient_id": patient['npid'],
          "requesting_clinician": requesting_clinician || nil,
          "sample_type": params[:sample_type],
          "tests": tests,
          "date_sample_drawn": "",
          "sample_priority": params[:priority],
          "target_lab": params[:target_lab],
          "reason_for_test": params[:priority],         
          "sample_collector_last_name": first_name || nil,
          "sample_collector_first_name": last_name || nil,
          "sample_collector_phone_number": '',
          "sample_collector_id": '',
          "sample_order_location": session[:ward],
          "tracking_number": "",
          "status": "not drawn",
          "art_start_date": "",
          "date_dispatched": "",
          "date_received": "",             
          "return_json": 'true'
        }

   submite_order_request(order)
   redirect_to "/scan_patient_barcode?option=request_order"
  end
  

	def confirm_order
    @order = session[:order]
    render :layout => false 
	end

	def submite_order
    order = session[:order]
    name = order[:sample_collector_first_name].to_s+" "+ order[:sample_collector_last_name].to_s
    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
    request = "#{api_url['national-repo-node']}#{api_resources['create_order']}"
    dat = JSON.parse(RestClient.post(request,order))      
    p_name = order['first_name'].to_s + " " +  order['middle_name'] +" "+order['last_name'].to_s
    UndispatchedSample.capture_sample(dat['tracking_number'],order['sample_type'],order['national_patient_id'],
                                  p_name,order['date_sample_drawn'],order['gender'],order['target_lab'],session[:ward])
    session[:un_dis_sample] = session[:un_dis_sample] + 1
    print_and_redirect("/print_tracking_number?tracking_number="+dat['tracking_number'].to_s+"&col_name="+name.to_s+"&sample="+order[:sample_type].to_s+"&priority="+order[:sample_priority].to_s,"/scan_patient_barcode?option=order_test")
     
		session.delete(:order)
  
	end

  def submite_order_request(order_requested)
        order = order_requested    
        name = order[:sample_collector_first_name].to_s+" "+ order[:sample_collector_last_name].to_s
        api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
        api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
        request = "#{api_url['national-repo-node']}#{api_resources['create_order']}"
        dat = JSON.parse(RestClient.post(request,order))
        UndrawnSample.capture_order_request(order,dat['tracking_number'])       
        session[:requested_sample]  = session[:requested_sample]  + 1
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

  def print_tracking_number  
      require 'auto12epl.rb'
      tracking_number = params[:tracking_number]
      col_name = params[:col_name]
      sample = params[:sample]
      priority = params[:priority]
      auto = Auto12Epl.new
      patient = session[:patient_demo]
      name = patient['name'].split(" ")
      age = 0
      dob = ""
      date = Time.now().strftime("%Y%m%d%H%M%S")
      aligned_lbl =  auto.generate_epl(name[0].to_s, name[1].to_s,"",patient['npid'].to_s,dob.to_s,age.to_s,patient['gender'].to_s,date, col_name.to_s, sample,priority.to_s,
                             tracking_number.to_s, tracking_number.to_s
      )   
      send_data(aligned_lbl,
              :type=>"application/label; charset=utf-8",
              :stream=> false,
              :filename=>"#{tracking_number}-#{rand(10000)}.lbl",
              :disposition => "inline"
      )  
  end

  def print
      require 'auto12epl.rb'
      tracking_number = params[:tracking_number]
      col_name = params[:col_name]
      sample = params[:sample]
      priority = params[:priority]
      auto = Auto12Epl.new
      name = params[:name]
      dob = params[:dob]
      gender = params[:gender]
      age = params[:age]
      npid = params[:npid]
      date = Time.now().strftime("%Y%m%d%H%M%S")
      aligned_lbl =  auto.generate_epl(name[0].to_s, name[1].to_s,"",npid.to_s,dob.to_s,age.to_s,gender.to_s,date, col_name.to_s, sample,priority.to_s,
                             tracking_number.to_s, tracking_number.to_s
      )   

      send_data(aligned_lbl,
              :type=>"application/label; charset=utf-8",
              :stream=> false,
              :filename=>"#{tracking_number}-#{rand(10000)}.lbl",
              :disposition => "inline"
      )  
  end

	def view_sample_test_results
    id = session[:patient_demo]['npid']
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
    @samples = UndrawnSample.retrieve_requested_samples(session[:ward])
    render :layout => false
	end

  def draw_sample
    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
    request = "#{api_url['central_repo']}#{api_resources['update']}"
    tracking_number = params[:tracking_number] 
    option = params[:option]

    if option != "all"
  
      data = {
        "sample_status": "Drawn",
        "_id": tracking_number
      }
        res = RestClient.post(request,data.to_json, :content_type => 'application/json')    
        sample =  UndrawnSample.retrive_undrawn_sample(params[:tracking_number])
        sample_type = sample[0]['sample_type']
        order_priority = "stat"               
        name = sample[0]['patient_name']
        npid = sample[0]['patient_id']
        gender = sample[0]['patient_gender']
        age = 0
        dob = sample[0]['date_of_birth']
        col_name = sample[0]['requested_by']
        session[:requested_sample] = session[:requested_sample] - 1
        UndrawnSample.remove_sampl(tracking_number)
        print_and_redirect("/print?tracking_number="+tracking_number.to_s+"&name="+name.to_s+"&npid="+npid.to_s+"&gender="+gender.to_s+"&age="+age.to_s+"&dob="+dob.to_s+"&col_name="+col_name.to_s+"&sample="+sample_type.to_s,"/draw_sample")
    
    elsif option == "all"
      tracking_numbers = eval(tracking_number)

      tracking_numbers.each do |tracking_number|
        data = {
        "sample_status": "Drawn",
        "_id": tracking_number
        }
        res = RestClient.post(request,data.to_json, :content_type => 'application/json')    
        sample =  UndrawnSample.retrive_undrawn_sample(tracking_number)
        sample_type = sample[0]['sample_type']
        order_priority = "stat"              
        name = sample[0]['patient_name']
        npid = sample[0]['patient_id']
        gender = sample[0]['patient_gender']
        age = 0
        dob = sample[0]['date_of_birth']
        col_name = sample[0]['requested_by']
        session[:requested_sample] = session[:requested_sample] - 1
        UndrawnSample.remove_sampl(tracking_number)
        print_and_redirect("/print?tracking_number="+tracking_number.to_s+"&name="+name.to_s+"&npid="+npid.to_s+"&gender="+gender.to_s+"&age="+age.to_s+"&dob="+dob.to_s+"&col_name="+col_name.to_s+"&sample="+sample_type.to_s,"/draw_sample")
    
      end
    end

      
  end
	
  def order_request_page_loader_handler

  end


end













