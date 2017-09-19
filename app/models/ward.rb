class Ward < ApplicationRecord

	def self.retrieve_wards
		wards = Ward.find_by_sql("SELECT wards.name FROM wards")
		return wards
	end

	def self.add_ward(ward,category)

	end

	def self.check_ward(ward,category)
		status = false

		return status
	end	
end
