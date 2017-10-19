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

	def save_dispatcher_details
		
		d_id = params[:dis][:id]
		d_f_name = params[:dis][:f_name]
		d_l_name = params[:dis][:l_name]
		d_phone = params[:dis][:phone]
		trac = session[:dis_sample].split(",")
	    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
	    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
	    request = "#{api_url['national_dashboard']}#{api_resources['capture_dispatcher']}?id="+trac.to_s + 
	    				"&f_name=" + d_f_name + "&l_name=" + d_l_name + "&phone=" + d_phone + "&p_id=" + d_id
	    RestClient.post(request,"")
	   	
	   	trac.each do |r|	   		
	   		UndispatchedSample.remove_dispatched_sample(r)
	   		session[:un_dis_sample] = session[:un_dis_sample] - 1
	   	end

	   	redirect_to '/view_undispatched_samples'
	end
	
end
