class UserType < ApplicationRecord


	def self.get_designation_id(type)

		type_name = UserType.find_by_sql("SELECT id,name  from user_types")

		if type_name.blank?
		else
			type_name.each do |row|
				next if row['name'] != type
				id = row['id']
				return id
			end
		end
	end

	def self.get_user_types
		types = UserType.find_by_sql("SELECT user_types.name FROM user_types")
		return types
	end

	def self.get_user_type_id(type_name)

		data = UserType.find_by(name: type_name[:name])
		if !data.blank?
			return data['id']
		end
	end

	def self.get_type_id(type_name)		
		data = UserType.find_by(name: type_name)
		if !data.blank?
			return data['id']
		end
	end

	def self.get_user_type_name(type_id)
		user_name = Role.find_by_sql("SELECT name AS user_name FROM user_types where id='#{type_id}'")
		if !user_name.blank?
			return user_name[0].user_name
		end
	end

end
