class RolesController < ApplicationController

	def roles_page_loader_handler	
		@roles = Role.get_system_roles
		@types = UserType.get_user_types
		@a_roles = []
		@asigned_roles = {}

		@types.each do |ty|
			type_id = UserType.get_user_type_id(ty)
			@roles.each do |r|

				role_id = Role.get_role_id(r)

				given_role = UserTypeRole.get_right(role_id,type_id)

				if given_role.blank?
					@a_roles.push("no")
				else

					@a_roles.push(given_role)
				end
	
			end
			@asigned_roles[ty[:name]] = @a_roles
			@a_roles = []
		end
	 @asigned_roles
	end

	def insert_update_user_roles
		details = params
		role_keys = params.keys
		user_types = []
		roles = []
		role_keys.each do |r|
			value = r.split("_")[1]
			value2 = r.split("_")[0]			
			if user_types.include?(value) 
			else
				user_types.push(value)
			end

			if roles.include?(value2)				
			else
				roles.push(value2)
			end			
		end

		user_types.each do |type|
			next if type.blank?
			roles.each do |r|
			next if r.blank? or r == "controller" or r =="action"
				role_id = Role.get_id(r)
				user_id = UserType.get_type_id(type)
				value = details[r +"_"+type]
				if !value.blank?
					if UserTypeRole.check_user_role(role_id,user_id) == false
		                 UserTypeRole.insert_role(role_id,user_id,value)                 
					else
						puts value
					 	 UserTypeRole.update_role(role_id,user_id,value) 
					end
				end
			end
		end
	end
end
