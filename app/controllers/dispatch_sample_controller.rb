class DispatchSampleController < ApplicationController


	def dispatch_sample_main_page_loader_handler
		@row = UndispatchedSample.count_undispatched_samples_by_target_lab
		
	end

	def retrive_undispatched_samples
		@@rows = []
		lab = params[:lab]
		@@rows = UndispatchedSample.retrive_undispatched_samples(lab)
		
		redirect_to '/view_undispatched_samples'
	end

	def view_undispatched_sample
		@row = @@rows

	end

	def capture_dispatcher
		@@trac = params[:trac]

	end

	def save_dispatcher_details
		
		d_id = params[:dis][:id]
		d_f_name = params[:dis][:f_name]
		d_l_name = params[:dis][:l_name]
		d_phone = params[:dis][:phone]

	    api_resources = YAML.load_file("#{Rails.root}/api/api_resources.yml")
	    api_url =  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]   
	    request = "#{api_url['national_dashboard']}#{api_resources['capture_dispatcher']}?id="+@@trac + 
	    				"&f_name=" + d_f_name + "&l_name=" + d_l_name + "&phone=" + d_phone + "&p_id=" + d_id
	    RestClient.post(request,"")
	   	
	   	UndispatchedSample.remove_dispatched_sample(@@trac)

	   	redirect_to '/undispatched_samples',  flash: {success: "sample(s) dispatched"}
	end
	
end
