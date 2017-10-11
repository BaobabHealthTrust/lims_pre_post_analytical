
class UserController < ApplicationController
	@@roles = []
	def form_loader
		@wards = (Ward::retrieve_wards).pluck(:name)
	end

	def main_home
		@role = @@roles
		@undispatched_sample_count = UndispatchedSample.count_undispatched_samples(session[:ward])
		@requested_sample = UndrawnSample.count_requested_samples(session[:ward])
		session[:un_dis_sample] = @undispatched_sample_count
		session[:requested_sample] = @requested_sample
		render :layout => false		
	end

	def log_in_handler
		status = User::log_in(params[:user][:username],params[:user][:password])		
		
		if status[0] == true
			@@roles = status[1]			
			session[:ward] = params[:ward_location]
			session[:user] = status[2]['id']
		 	redirect_to '/home'
		else
		 	redirect_to  '/' , flash: {error: "wrong password or username"}
		end

		
	end

	def add_user
		_id = params[:user][:id]
		first_name =  params[:user][:first_name]
		last_name =  params[:user][:last_name]
		email =  params[:user][:email]
		phone_number =  params[:user][:phone_number]
		username =  params[:user][:username]
		password =  params[:user][:password]
		designation = params[:designation]
		gender = params[:gender]

		if User.check_user(username) == false			
				designation_id =  UserType.get_designation_id(designation)
				User.add_user(_id,first_name,last_name,gender,email,phone_number,username,password,designation_id)
				redirect_to '/view_settings?added=' + "yes"
		else
			redirect_to '/add_user_page_loader', 
			flash: {error: "username is taken, consider having another"}
		end

	end

	def add_user_page_loader_handler
		@user_types = (UserType.get_user_types).pluck(:name)

	end

	def view_user_page_loader_handler
		@rows = User.get_users

		render :layout => false	
	end

	def log_out_handler

	end

	def user_registration_handler

	end

	def settings_event_handler
		render :layout => false	
	end

	def search_user_by_username
		user_name = params[:name]
		
		rst = User.search_user_by_username(user_name)
		user_id = UserType.get_type_id(rst[0].designation)	
		roles = UserTypeRole.get_user_right(user_id)
		render :json => [rst,roles].to_json
	end


	def delete_user
		staff = params[:staff]
		User.delete_user(staff)

		render plain: "done"
	end

end
