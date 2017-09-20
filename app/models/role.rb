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
		data = Role.find_by(name: role_name[:name])
		if !data.blank?
			return data['id']
		end
	end

	def self.get_id(role_name)		
		data = Role.find_by(name: role_name)
		if !data.blank?
			return data['id']
		end
	end

	def self.get_role_name(role_id)
		role_name = Role.find_by_sql("SELECT name AS role_name FROM  roles where id='#{role_id}'")
		if !role_name.blank?
			return role_name[0].role_name
		end
	end


end
