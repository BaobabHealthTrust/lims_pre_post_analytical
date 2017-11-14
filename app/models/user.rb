class User < ApplicationRecord

	cattr_accessor :current

	def self.log_in(username,password)
		user = User.find_by_sql("SELECT * FROM users WHERE username='#{username}'")
		status = false
		if !user.blank?
			user = user[0]
			secured_password = BCrypt::Password.new(user[:password])	
			if secured_password == password
				roles = self.get_user_type(user[:user_type_id])
				status = true
			end		
		end
		return status, roles, user
	end

	def self.get_user_type(type_id)
		roles = UserTypeRole.get_user_right(type_id)
		return roles
	end

	def self.get_user(got_id)
		user = User.find_by_sql("SELECT * FROM users WHERE id='#{got_id}'")
		if !user.blank?
			return user[0]
		end
	end

	def self.add_user(_id,first_name,last_name,sex,email,phone_number,username,password,designation)
		password_has = BCrypt::Password.create(password)
		user = User.new()
		user.staff_id = _id
		user.name = first_name +" "+ last_name
		user.sex = sex
		user.username = username
		user.password = password_has
		user.email = email
		user.phoneNumber = phone_number
		user.user_type_id = designation
		user.save		
	end

	def self.check_user(username)
		status = false
		user = User.find_by_sql("SELECT users.name,users.username,users.password FROM users WHERE users.username ='#{username}'")

		if user.blank?
			return status
		else
			return status = true
		end
	end

	def check_password_length(password)
		if password.length <6
			return true
		else
			return false
		end
	end

	def self.search_user_by_username(user_name)
		rst = User.find_by_sql("SELECT users.username AS Username, user_types.name AS designation FROM users INNER JOIN user_types ON user_types.id = users.user_type_id  WHERE users.username='#{user_name}'")
		if !rst.blank?
			return rst
		else
			return "false"
		end

	end


	def self.search_user_by_id(user_id)
		rst = User.find_by_sql("SELECT * FROM users WHERE users.id='#{user_id}'")
		if !rst.blank?
			return rst
		else
			return "false"
		end

	end

	def self.get_users
		row = User.find_by_sql("SELECT users.staff_id,users.username, users.name AS user_name, users.sex,users.email,users.phoneNumber, user_types.name FROM users 
								INNER JOIN user_types ON users.user_type_id = user_types.id")		
		if (!row.blank?)
			return row
		end

	end


	def self.delete_user(staff)
		user = User.find_by(:staff_id => staff)
		user.destroy();
	end


		
end	
