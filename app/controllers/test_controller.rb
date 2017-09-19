class TestController < ApplicationController

	def add_test_handler
		@test_types = ['Renal Function','Glocus Test','Preg Test','Liver Function']
		@test_types =  @test_types - session[:order]['tests']
		
	end

	def remove_test_from_order		
			test_name = params[:test_name]
			session[:order]['tests'].delete(test_name)			
	end

	def add_test
		new_test = params[:test]
		new_test.each do |test|
			next if test.empty?
			session[:order]['tests'].push(test)
		end	
		redirect_to   '/confirm_order' 
	end	
end
