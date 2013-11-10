class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
  	user = User.find_by(email: params[:email])
  	delivered = user.send_password_reset unless user.nil?
  	if user.nil?
	  theflash = { error: "Account not found with email #{params[:email]}" }
  	else
	  theflash = { notice: "Email sent with password reset instructions." }	
	end
  	redirect_to :root, theflash
  end
end
