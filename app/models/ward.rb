class Ward < ApplicationRecord

	def self.retrieve_wards
		wards = Ward.find_by_sql("SELECT * FROM wards")
		return wards
	end

	def self.add_ward(ward,category)

	    wrd = Ward.new
	    wrd.name = ward
	    wrd.category = category
	    wrd.save()

	end

	def self.check_ward(ward,category)
	
		rst = Ward.find_by_sql("SELECT * FROM wards WHERE wards.name='ward' AND wards.category='category'")

		if (rst.blank?)
		
			return false
		
		else
		
			return true
		end
	end	

	def self.delete_ward(ward_id)
		Ward.find_by_sql("DELETE FROM wards WHERE wards.id='#{ward_id}'")
	end

end
