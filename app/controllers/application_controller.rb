class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token  
  
  after_action :check_user, except: ['form_loader','log_in_handler']


  def check_user 	
  	if not session[:user_id].blank?
      User.current = User.where(:id => session[:user_id]).first
      #Location.current = Location.where(:name => session[:location]).first
      User.current = nil
	  session.delete('user_id')
    end
  end



  def print_and_redirect(print_url, redirect_url, message = "Printing, please wait...", show_next_button = false, patient_id = nil)
    @print_url = print_url    
    @redirect_url = redirect_url
    @message = message
    @show_next_button = show_next_button
    @patient_id = patient_id
    render :template => 'print/print', :layout => nil
  end

end
