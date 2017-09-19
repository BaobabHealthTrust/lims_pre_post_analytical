class TargetLabController < ApplicationController

	def target_lab_main_page_loader_handler

	end


	def add_targer_lab_page_loader_handler

	end

	def add_target_lab
		lab_name = params[:lab][:name]
		site_code = params[:lab][:site_code]
		hosp = params[:lab][:hospital]
		district = params[:lab][:district]
		address = params[:lab][:address]
		phone = params[:lab][:phone]
		if TargetLab.check_lab(lab_name,site_code,hosp,district,address,phone) == false
			TargetLab.add_target_lab(lab_name,site_code,hosp,district,address,phone)
			redirect_to '/ward_main_page_loader'

		else
			redirect_to '/ward_main_page_loader'

		end	
	end


end
