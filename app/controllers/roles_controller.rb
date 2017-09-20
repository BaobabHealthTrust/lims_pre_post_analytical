class RolesController < ApplicationController

	def roles_page_loader_handler	
		@roles = Role.get_system_roles
		@types = UserType.get_user_types
	end

	def try
			raise params[:id].inspect
	end
end
