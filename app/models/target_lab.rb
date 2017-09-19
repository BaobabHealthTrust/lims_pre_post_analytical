class TargetLab < ApplicationRecord

	def self.add_target_lab(name,phone,district)
		lab = TargetLab.new()
		lab.name = name
		lab.district_id = district
		lab.phone_number = phone
		lab.save		
	end

	def self.check_lab(lab_name,district)
		lab = TargetLab.find_by_sql("SELECT target_labs.id FROM target_labs WHERE target_labs.name='#{lab_name}' AND target_labs.district_id='#{district}' ")
		if lab.blank?
			return false
		else
			return true
		end	
	end

	def self.get_target_labs
		labs = TargetLab.find_by_sql("SELECT * FROM target_labs")
		if labs.blank?
		 	return "no labs"
		else
			return labs
		end		
	end

	def self.delete_target_lab(lab_id)
		TargetLab.find_by_sql("DELETE FROM target_labs WHERE target_labs.id='#{lab_id}'")
	end
end
