class TestController < ApplicationController

	def add_test_handler

	end

	def remove_test_from_order		
			test_name = params[:test_name]
			session[:order]['test'].delete(test_name)			
	end

	def add_test
		new_test = params[:test]
		new_test.each do |test|
			next if test.empty?
			session[:order]['test'].push(test)
		end	

		redirect_to   '/confirm_order' 
	end


	
end
