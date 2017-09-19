
class UserController < ApplicationController

	def form_loader
		@wards = (Ward::retrieve_wards).pluck(:name)
	end

	def main_home
		
		render :layout => true

	end


	def log_in_handler
		status = User::log_in(params[:user][:username],params[:user][:password])
		if status == true
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

end
