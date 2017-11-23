class SampleOrderController < ApplicationController

  def home
     
  end
  
  def view_recent_result
    id = session[:patient_demo]['npid']
    @patient_demo = session[:patient_demo]
    url = "localhost:3005/api/patient_lab_trail?npid=#{id}"

    results = JSON.parse(RestClient.get(url,:contentType => "application/text"))
    check = results
    result_measuers = {} 
    details = []
    @test_status = {}
    dates = []

    check.each do |r|
      dates.push(r['date_time'])
    end

    latest_order = dates.max
    results.each do |rst|
        next if rst['date_time'] != latest_order
        @id = rst["_id"]
        @test_types = rst['results'].keys
        @sample_type = rst["sample_type"]
        @status = rst["status"]
        @date = rst["date_time"]
        @test_types.each do |test|
          
          if rst['results'][test].length < 4
            key = rst['results'][test].keys[rst['results'][test].length - 1]
            test_status = rst['results'][test][key]['test_status']
            result_measuers[test] = {"measure_name" => "null","result" => "null"}
            @test_status[test] = "not available"+ "_"+ test_status
          elsif rst['results'][test].length >= 4
            results = rst['results'][test].keys
            if rst['results'][test].length == 4
                results = results[3]
               
                if rst['results'][test][results]['test_status'] == "verified"
                  rst['results'][test][results]['results'].each do |s|

                    details.push({"measure_name" => s[0],"result" => s[1]})
                    @test_status[test] = "available" +"_"+"authorised"
                  end
                end
            elsif rst['results'][test].length >= 5
                
                if rst['results'][test].length == 6
                   results = results[5]
                 
                  if rst['results'][test][results]['test_status'] == "verified"
                    rst['results'][test][results]['results'].each do |s|

                      details.push({"measure_name" => s[0],"result" => s[1]})
                      @test_status[test] = "available" +"_"+"authorised"
                    end
                  elsif  rst['results'][test][results]['test_status'] == "completed"
                      rst['results'][test][results]['results'].each do |s|

                      details.push({"measure_name" => s[0],"result" => s[1]})
                      @test_status[test] = "available" +"_"+"authorised"
                    end
                  end
                elsif rst['results'][test].length == 5

                     results = results[4]
                  if rst['results'][test][results]['test_status'] == "verified"
                    rt['results'][test][results]['results'].each do |s|

                      details.push({"measure_name" => s[0],"result" => s[1]})                  
                      @test_status[test] = "available" +"_"+"authorised"
                    end
                  elsif rst['results'][test][results]['test_status'] == "completed"  
                      result_measuers[test] = {"measure_name" => "null","result" => "null"}
                      @test_status[test] = "not available"+ "_"+ "completed but Unauthorised"
                  end
                end

            end
          result_measuers[test] = details
          session[:rs] =  result_measuers          
          details = []
          end 
        end
      end
   


    render :layout => false
  end

  def capture_order_details
    tests = params[:test]
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

    tests = tests.delete_if(&:empty?)
    lab = params[:target_lab]
    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
    request = "#{api_url['national_dashboard']}#{api_resources['retrieve_lab_catalog']}?lab="+lab
    cat = JSON.parse(RestClient.post(request,""))  
    pan_test = cat['test_panels']
    panels = cat['test_panels'].keys
    if tests.include?("MC&S") && tests.include?("CSF Analysis")
      
        panels.each do |panel|
          next if panel == "MC&S"
          if tests.include?(panel)
              pan_test[panel].each do |tst|
              tests.push(tst)
            end           
          end
        end
    else
        panels.each do |panel|
          if tests.include?(panel)
              pan_test[panel].each do |tst|
              tests.push(tst)
            end              
          end
        end
    end


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


  def tab_submite_order_request
    test = params[:test]
    sample_type = session[:lab_sample][0]
    lab = session[:lab_sample][1]
    patient = session[:tab_patients] 

    tests = test.split(",")
    tests = tests.delete_if(&:empty?)

    patient_name = patient[0].split(" ")
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
          "date_of_birth": patient[2] || nil,
          "gender": patient[1],
          "national_patient_id": patient[4],
          "requesting_clinician": requesting_clinician || nil,
          "sample_type": sample_type,
          "tests": tests,
          "date_sample_drawn": "",
          "sample_priority": "",
          "target_lab": lab,
          "reason_for_test": "",         
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

     

  end
  

  def confirm_order
    @order = session[:order]
    @patient_demo = session[:patient_demo]
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
    print_and_redirect("/print_tracking_number?tracking_number="+dat['tracking_number'].to_s+"&col_name="+name.to_s+"&sample="+order[:sample_type].to_s+"&priority="+order[:sample_priority].to_s,"/patient_dashboard")
    session.delete(:order)
  
  end

  def submite_order_request
        order = session[:order]
     
        order["status"] = "not-drawn"
        name = order[:sample_collector_first_name].to_s+" "+ order[:sample_collector_last_name].to_s
        api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
        api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
        request = "#{api_url['national-repo-node']}#{api_resources['create_order']}"
        dat = JSON.parse(RestClient.post(request,order))
        UndrawnSample.capture_order_request(order,dat['tracking_number'])       
        session[:requested_sample]  = session[:requested_sample]  + 1
        session.delete(:order)  
        redirect_to "/patient_dashboard"
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

  def get_sample
    lab = params[:lab]
    cat =  SampleOrderController.retrieve_lab_catalog(lab) 
    render :json => cat["samples"]
  end

  def get_test_types
     sample = params[:sample_name]
     test_types = @@dat['tests'][sample]
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
    @patient_demo = session[:patient_demo]
    url = "localhost:3005/api/patient_lab_trail?npid=#{id}"

    @sample_results = JSON.parse(RestClient.get(url,:contentType => "application/text"))
    @@sample_results_glo =  @sample_results
    render :layout => false 
  end

  def view_individual_sample_test_results
    @patient_demo = session[:patient_demo]
    results = @@sample_results_glo
    @id = params[:id].split('_')[1]
    result_measuers = {} 
    details = []
    @test_status = {}
    results.each do |rst|
        next if rst['_id'] != @id
        @test_types = rst['results'].keys

        @test_types.each do |test|

          if rst['results'][test].length < 4
            key = rst['results'][test].keys[rst['results'][test].length - 1]
            test_status = rst['results'][test][key]['test_status']
            result_measuers[test] = {"measure_name" => "null","result" => "null"}
            @test_status[test] = "not available"+ "_"+ test_status
          elsif rst['results'][test].length >= 4
            results = rst['results'][test].keys
            if rst['results'][test].length == 4
                results = results[3]
               
                if rst['results'][test][results]['test_status'] == "verified"
                  rst['results'][test][results]['results'].each do |s|

                    details.push({"measure_name" => s[0],"result" => s[1]})
                    @test_status[test] = "available" +"_"+"authorised"
                  end
                end
            elsif rst['results'][test].length >= 5
                if rst['results'][test].length == 6
                   results = results[5]
                 
                  if rst['results'][test][results]['test_status'] == "verified"
                    rst['results'][test][results]['results'].each do |s|

                      details.push({"measure_name" => s[0],"result" => s[1]})
                      @test_status[test] = "available" +"_"+"authorised"
                    end
                  end
                elsif rst['results'][test].length == 5
                     results = results[4]
                  if rst['results'][test][results]['test_status'] == "verified"
                    rst['results'][test][results]['results'].each do |s|

                      details.push({"measure_name" => s[0],"result" => s[1]})                  
                      @test_status[test] = "available" +"_"+"authorised"
                    end
                  elsif rst['results'][test][results]['test_status'] == "completed"  
                      result_measuers[test] = {"measure_name" => "null","result" => "null"}
                      @test_status[test] = "not available"+ "_"+ "completed but Unauthorised"
                  end
                end

            end


          result_measuers[test] = details
          session[:rs] =  result_measuers          
          details = []
          end 
        end
        render :layout => false 
    end
      
  end

  def tab_view_individual_sample_test_results
    results = @@sample_results_glo
    @id = params[:id].split('_')[1]
    result_measuers = {} 
    details = []
    @test_status = {}
    results.each do |rst|
        next if rst['_id'] != @id
        @test_types = rst['results'].keys

        @test_types.each do |test|

          if rst['results'][test].length < 4

            result_measuers[test] = {"measure_name" => "null","result" => "null"}
            @test_status[test] = "not available"
          elsif rst['results'][test].length >= 4
            results = rst['results'][test].keys
            if rst['results'][test].length == 4
                results = results[3]
               
                if rst['results'][test][results]['test_status'] == "verified"
                  rst['results'][test][results]['results'].each do |s|

                    details.push({"measure_name" => s[0],"result" => s[1]})
                    
                  end
                end
            elsif rst['results'][test].length >= 5
                if rst['results'][test].length == 6
                   results = results[5]
                 
                  if rst['results'][test][results]['test_status'] == "verified"
                    rst['results'][test][results]['results'].each do |s|

                      details.push({"measure_name" => s[0],"result" => s[1]})
                      
                    end
                  end
                elsif rst['results'][test].length == 5
                     results = results[4]
                 
                  if rst['results'][test][results]['test_status'] == "verified"
                    rst['results'][test][results]['results'].each do |s|

                      details.push({"measure_name" => s[0],"result" => s[1]})
                      
                    end
                  end
                end

            end

          result_measuers[test] = details
          session[:rs] =  result_measuers
          @test_status[test] = "available"
          details = []
          end           
        end

        render :layout => false 
    end
  end

  def tab_view_sample_results
      id = params[:id];
      url = "localhost:3005/api/patient_lab_trail?npid=#{id}"

      @sample_results = JSON.parse(RestClient.get(url,:contentType => "application/text"))
      @@sample_results_glo =  @sample_results
      render :layout => false 
  end

  def tab_request_sample
    id = params[:id]
    session[:tab_patients] = session[:tab_patients][id]

    render :layout => false
  end

  def get_result_measures
    test_type = params[:type]
    measures = session[:rs][test_type]
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

  
  

  def print_sample
    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
    request = "#{api_url['central_repo']}#{api_resources['update']}"
    tracking_number = params[:tracking_number] 
    option = params[:option]

    if session[:b_drawn].blank?
      session[:b_drawn] = tracking_number
    else
      session[:b_drawn] = session[:b_drawn] +"_"+ tracking_number      
    end

        sample =  UndrawnSample.retrive_undrawn_sample(params[:tracking_number])
        sample_type = sample[0]['sample_type']
        order_priority = "stat"               
        name = sample[0]['patient_name']
        npid = sample[0]['patient_id']
        gender = sample[0]['patient_gender']
        age = 0
        dob = sample[0]['date_of_birth']
        col_name = sample[0]['requested_by']
        print_and_redirect("/print?tracking_number="+tracking_number.to_s+"&name="+name.to_s+"&npid="+npid.to_s+"&gender="+gender.to_s+"&age="+age.to_s+"&dob="+dob.to_s+"&col_name="+col_name.to_s+"&sample="+sample_type.to_s,"/draw_sample")
 

      
  end
  
  def draw_sample
    samples =  params[:samples]
    samples = samples.split(",");

    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
    request = "#{api_url['central_repo']}#{api_resources['update']}"
    tracking_number = params[:tracking_number] 
    option = params[:option]

    samples.each do |sample|
      data = {
        "sample_status": "Drawn",
        "_id": sample
      }


       sampl =  UndrawnSample.retrive_undrawn_sample(sample)
        sample_type = sampl[0]['sample_type']
        order_priority = "stat"               
        name = sampl[0]['patient_name']
        npid = sampl[0]['patient_id']
        gender = sampl[0]['patient_gender']
        age = 0
        dob = sampl[0]['date_of_birth']
        col_name = sampl[0]['requested_by']
        ward = sampl[0]['order_location']
        date_requested = sampl[0]['date_requested']

        UndispatchedSample.capture_sample(sample,sample_type,npid,name,date_requested,gender,"KCH",ward)
        session[:un_dis_sample] = session[:un_dis_sample] + 1
        res = RestClient.post(request,data.to_json, :content_type => 'application/json')    
        session[:requested_sample] = session[:requested_sample] - 1
        UndrawnSample.remove_sampl(sample)
        session.delete(:b_drawn)
    end
    redirect_to "/draw_sample"
  end


  def get_samples_to_be_drawn
    render plain: session[:b_drawn]
  end

  def 

  def scan_undrawn_samples_loader
    render  :layout => false
  end


  def order_request_page_loader_handler

  end


end












