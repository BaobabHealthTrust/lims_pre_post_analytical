class User < ApplicationRecord


	def self.log_in(username,password)
		user = User.find_by_sql("SELECT * FROM users WHERE username='#{username}'")
		status = false
		if !user.blank?
			user = user[0]
			secured_password = BCrypt::Password.new(user[:password])	
			if secured_password == password
				status = true
			end		
		end
		return status
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
		
end	
