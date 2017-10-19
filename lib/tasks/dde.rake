namespace :dde do
  desc "TODO"
  task authenticate: :environment do
  	api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    api_url =  YAML.load_file("#{Rails.root}/config/dde3.yml")[Rails.env]   
    request = "#{api_url['dde_url']}#{api_resources['authenticate']}"
    data = {
    	   "username": "#{api_url['dde_default_username']}",
    	   "password": "#{api_url['dde_default_password']}"
    }
    res = JSON.parse(RestClient.post(request,data.to_json, :content_type => 'application/json'))
    if res['status'] == 200
    	token = res['data']
    	token = token['token'].to_s

    	if token.present?
    		File.open("#{Rails.root}/tmp/token", 'w') {|f|
    	     f.write(token) } 
    	     puts "authentication successfuly done!!!! can create user now"
        end    
    else 
    	puts "error"   
    	puts "status: " +res['status'] + "error_type: "+ res['message']
    end     
  end


  desc "TODO"
  task create_user: :environment do
  	api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    api_url =  YAML.load_file("#{Rails.root}/config/dde3.yml")[Rails.env]     
    token = File.read("#{Rails.root}/tmp/token")
    token = token
    request = "#{api_url['dde_url']}#{api_resources['validate_token']}/#{token}" 
    res = JSON.parse(RestClient.get(request)) rescue nil if !token.blank?

    if res['status'] == 200
              if token.present?                
                    	data = { 
                        	"username": "#{api_url['dde_application_username']}",
                	        "password": "#{api_url['dde_application_password']}",
                	        "application": "#{api_url['application_name']}",
                	        "site_code": "#{api_url['site_code']}",
                	        "token": "#{token}",
                	        "description": "Lims Order Entry for #{api_url['site_code']}"    
                    		}   
                      request = "#{api_url['dde_url']}#{api_resources['create_user']}"  	  
                    	res = JSON.parse(RestClient.put(request,data.to_json, :content_type => 'application/json'))    	
                    	if res['status'] == 201
                	    	  puts "user successfuly created!!!!"
                	        
                	    else 
                	    	puts "error"   
                	    	puts "status: " +res['status'].to_s+"error_type: "+res['message'].to_s
                	    end                     							
              end
    elsif res['status'] == 401
            api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
            api_url =  YAML.load_file("#{Rails.root}/config/dde3.yml")[Rails.env]   
            request = "#{api_url['dde_url']}#{api_resources['authenticate']}"
            data = {
                 "username": "#{api_url['dde_default_username']}",
                 "password": "#{api_url['dde_default_password']}"
            }
            res = JSON.parse(RestClient.post(request,data.to_json, :content_type => 'application/json'))
            if res['status'] == 200
              token = res['data']
              token = token['token'].to_s

                if token.present?
                  File.open("#{Rails.root}/tmp/token", 'w') {|f|
                     f.write(token) } 
                     puts "authentication successfuly done!!!! now creating user"
                      data = { 
                            "username": "#{api_url['dde_application_username']}",
                            "password": "#{api_url['dde_application_password']}",
                            "application": "#{api_url['application_name']}",
                            "site_code": "#{api_url['site_code']}",
                            "token": "#{token}",
                            "description": "Lims Order Entry for #{api_url['site_code']}"    
                          }   
                        request = "#{api_url['dde_url']}#{api_resources['create_user']}"      
                        res = JSON.parse(RestClient.put(request,data.to_json, :content_type => 'application/json'))     
                        if res['status'] == 201
                            puts "user successfuly created!!!!"
                            
                        else 
                          puts "error"   
                          puts "status: " +res['status'].to_s+"error_type: "+res['message'].to_s
                        end   
                end    
            else 
              puts "error"   
              puts "status: " +res['status'] + "error_type: "+ res['message']
            end     
    end


  end

end
