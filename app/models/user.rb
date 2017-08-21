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

	def self.create_user(password)

		password_has = BCrypt::Password.create(password)

		return password_has
	
		
	end
		
end	
