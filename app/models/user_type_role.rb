class UserTypeRole < ApplicationRecord

	def self.insert_role(role,user,value)

		rw = UserTypeRole.new()
		rw.user_type_id = user
		rw.role_id = role
		rw.given_role = value
		rw.save()
	end

	def self.check_user_role(role,user)
		ch = UserTypeRole.find_by_sql("SELECT * FROM user_type_roles WHERE user_type_id='#{user}' AND role_id='#{role}'")
		if ch.blank?
			return false
		else
			return true
		end
	end

	def self.update_role(role,user,value)
		rw = UserTypeRole.find_by(user_type_id: user, role_id: role)
		rw.given_role = value
		rw.save
	end

	def  self.get_user_right(role_id,user_type_id)
	  gv_role = UserTypeRole.find_by_sql("SELECT given_role FROM user_type_roles WHERE user_type_id='#{user_type_id}' AND role_id='#{role_id}'")
		
		if !gv_role.blank?
			return gv_role[0].given_role
		end
	end

end
