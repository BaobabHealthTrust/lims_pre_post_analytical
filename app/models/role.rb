class Role < ApplicationRecord

	def self.get_system_roles
		roles = Role.find_by_sql("SELECT roles.name FROM roles")
		if roles.blank?
			return false
		else
			return roles
		end
	end

end
