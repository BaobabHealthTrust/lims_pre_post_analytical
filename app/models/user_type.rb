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



end
