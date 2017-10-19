require 'rest-client'

class Dde

	def check_token_validity
		token = File.read("#{Rails.root}/tmp/token")
		api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
    	api_url =  YAML.load_file("#{Rails.root}/config/dde3.yml")[Rails.env] 
    	request = "#{api_url['dde_url']}#{api_resources['validate_token']}/#{token}"
		res = JSON.parse(RestClient.get(request, :content_type => 'application/json')) rescue nil

		if !res.blank?
			if res['status'] == 401 || res == nil
				return false
			else
				return true
			end
		end
	end

	def authenticate_by_new_user
		api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
	    api_url =  YAML.load_file("#{Rails.root}/config/dde3.yml")[Rails.env]   
	    request = "#{api_url['dde_url']}#{api_resources['authenticate']}"
	    data = {
	    	   "username": "#{api_url['dde_application_username']}",
	    	   "password": "#{api_url['dde_application_password']}"
	    }
	    res = JSON.parse(RestClient.post(request,data.to_json, :content_type => 'application/json'))
	    if res['status'] == 200
	    	token = res['data']
	    	token = token['token'].to_s

	    	if token.present?
	    		File.open("#{Rails.root}/tmp/token", 'w') {|f|
	    	     f.write(token) } 
	    	     puts "authentication successfuly done!!!!"
	        end    
	    else 
	    	puts "error"   
	    	puts "status: " +res['status'] + "error_type: "+ res['message']
	    end     
	end

end




