class WardController < ApplicationController


	def ward_main_page_loader_handler

	end

	def add_ward_page_loader_handler

	end

	def add_ward
		ward_name = params[:ward_name]
		ward_category = params[:ward_category]
		
		if Ward.check_ward(ward_name,ward_category) == false
        	Ward.add_ward(ward_name,ward_category)
        	redirect_to '/ward_main_page_loader'
        else
        	redirect_to '/ward_main_page_loader'
        end	
	end

end
