class WardController < ApplicationController


	def ward_main_page_loader_handler
		@wards = (Ward::retrieve_wards)
	end

	def add_ward_page_loader_handler

	end

	def add_ward
		ward = params[:ward][:name]
		ward_category = params[:ward_category]
		if Ward.check_ward(ward,ward_category) == false
        	Ward.add_ward(ward,ward_category)
        	redirect_to '/ward_main_page_loader'
        else
        	redirect_to '/ward_main_page_loader'
        end	
	end

	def delete_ward
		ward_id = params[:ward_id]
		Ward.delete_ward(ward_id)

		render plain: "deletion done"
	end

end
