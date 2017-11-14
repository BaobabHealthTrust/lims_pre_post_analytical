class DispatchSampleController < ApplicationController


	def dispatch_sample_main_page_loader_handler
		@row = UndispatchedSample.count_undispatched_samples_by_target_lab(session[:ward])
		render :layout => false		
	end

	def retrive_undispatched_samples
		@@rows = []
		lab = params[:lab]
		session[:un_dispatched_sample] = UndispatchedSample.retrive_undispatched_samples(lab,session[:ward])
		
		redirect_to '/view_undispatched_samples'
	end

	def view_undispatched_sample
		@row = session[:un_dispatched_sample]
		render :layout => false	
	end

	def capture_dispatcher
		session[:dis_sample] = params[:trac]


	end

	def dispatch_sample
		
		render :layout => false
	end


	def save_dispatcher_details
		id = session[:user]
		user = User::get_user(id)
		name = user['name']
		sample_id = params[:id]
		d_f_name = name.split(" ")[0]
		d_l_name = name.split(" ")[1]
		d_phone = user["phoneNumber"]
	    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
	    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
	    request = "#{api_url['national_dashboard']}#{api_resources['capture_dispatcher']}?id="+sample_id.to_s + 
	    				"&f_name=" + d_f_name + "&l_name=" + d_l_name + "&phone=" + d_phone + "&p_id=" + id.to_s
	    RestClient.post(request,"")
	    UndispatchedSample.remove_dispatched_sample(sample_id)
	   	session[:un_dis_sample] = session[:un_dis_sample] - 1

	end
	
end
