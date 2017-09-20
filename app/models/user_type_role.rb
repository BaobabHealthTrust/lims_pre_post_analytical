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

end
