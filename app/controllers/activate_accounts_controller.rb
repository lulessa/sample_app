class ActivateAccountsController < ApplicationController

  def edit
  	activate_account_user(params[:id], params[:token])
  end
  
  def activate_account_user(user_id, token)
  	if @user = User.find_by!(id: user_id, confirm_token: token)
	  @user.activate
	  if @user.active?
		redirect_to user_path(@user), 
					notice: "Your email address #{@user.email} was confirmed!"
		return true
	  end
	end
	redirect_to new_user_path, alert: "User indicated in link does not exist or email confirmation token does not match."
	return false
  end
end