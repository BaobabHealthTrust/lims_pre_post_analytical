class TargetLabController < ApplicationController

	def target_lab_main_page_loader_handler
		@labs = TargetLab.get_target_labs
	end


	def add_targer_lab_page_loader_handler

	end

	def add_target_lab
		lab_name = params[:lab][:name]
		district = params[:district]		
		phone = params[:lab][:phone]

		if TargetLab.check_lab(lab_name,district) == false
			TargetLab.add_target_lab(lab_name,phone,district)
			redirect_to '/target_lab_main_page_loader', flash: {message: 'target lab created successfuly'}
		else
			redirect_to '/add_target_lab_page_loader', flash: {error: 'target lab already exist in the system'}
		end	
	end

	def delete_target_lab
		lab_id = params[:lab_id]
		TargetLab.delete_target_lab(lab_id)
	end

	def get_labs
		labs = TargetLab.get_target_labs
		render plain: labs.collect{|l| "<li>"+ l.name}.join("<li>")+"</li>"
	end

end
