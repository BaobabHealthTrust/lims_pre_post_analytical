class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token  
  
  after_action :check_user, except: ['form_loader']


  def check_user

  	
  	
  	if not session[:user_id].blank?
      User.current = User.where(:id => session[:user_id]).first
      #Location.current = Location.where(:name => session[:location]).first
      User.current = nil
	  session.delete('user_id')
    end
  end

end
