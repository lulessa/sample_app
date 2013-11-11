class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
  	user = User.find_by(email: params[:email])
  	delivered = user.send_password_reset unless user.nil?
  	if user.nil?
	  redirect_to :new_password_reset, alert: "Account not found with email #{params[:email]}"
  	else
	  redirect_to :root, notice: "Email sent with password reset instructions."
	end
  end
  
  def edit
  	password_reset_user(params[:id])
  end
  
  def update
  	return false unless password_reset_user(params[:id])
  	user_params = params.require(:user).permit(:password, 
											   :password_confirmation)
  	if params[:user][:password].blank?
	  flash.now[:error] = "Password can't be blank"
  	elsif @user.update_attributes(user_params)
	  flash[:success] = "Your password has been reset"
	  redirect_to signin_path and return
	end
	render :edit
  end
  
  def password_reset_user(token)
  	if @user = User.find_by!(password_reset_token: token)
	  # || condition tests for nil user before checking expiration
	  return @user unless @user.nil? || password_reset_expired?
	end
	redirect_to new_password_reset_path, alert: "Password reset link has expired. Please request another link using the form below."
	return false
  end
  
  def password_reset_expired?
  	@user.password_reset_sent_at < 2.hours.ago
  end
end
