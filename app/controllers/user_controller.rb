
class UserController < ApplicationController
	@@roles = []
	def form_loader
		@wards = (Ward::retrieve_wards).pluck(:name)
	end

	def main_home
		@role = @@roles
		render :layout => true		
	end

	def log_in_handler
		status = User::log_in(params[:user][:username],params[:user][:password])		
		if status[0] == true
			@@roles = status[1]			
			session[:ward] = params[:ward_location]
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
				redirect_to '/view_settings', 
				flash: {error: "user created successfuly, username:#{' '+username} #{' '}& password:#{' '+password}"}
		else
			redirect_to '/add_user_page_loader', 
			flash: {error: "username is taken, consider having another"}
		end

	end

	def add_user_page_loader_handler
		@user_types = (UserType.get_user_types).pluck(:name)

	end

	def view_user_page_loader_handler
		
	end

	def log_out_handler

	end

	def user_registration_handler

	end

	def settings_event_handler
		
	end

	def search_user_by_username
		user_name = params[:name]
		rst = User.search_user_by_username(user_name)
		user_id = UserType.get_type_id(rst[0].designation)	
		roles = UserTypeRole.get_user_right(user_id)
		render :json => [rst,roles].to_json
	end

end
