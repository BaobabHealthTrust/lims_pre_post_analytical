class Ward < ApplicationRecord

	def self.retrieve_wards
		wards = Ward.find_by_sql("SELECT wards.name FROM wards")
		return wards
	end
end
