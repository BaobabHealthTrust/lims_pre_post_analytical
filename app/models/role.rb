class Role < ApplicationRecord

	def self.get_system_roles
		roles = Role.find_by_sql("SELECT roles.name FROM roles")
		if roles.blank?
			return false
		else
			return roles
		end
	end

	def self.get_role_id(role_name)
		id = Role.find_by_sql("SELECT id AS role_id FROM  roles where name='#{role_name}'")
		if !id.blank?
			return id[0].role_id 
		end
	end


end
