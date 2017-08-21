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

	def log_out_handler

	end

	def user_registration_handler

	end


end
