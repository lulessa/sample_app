class PasswordResetsController < ApplicationController

  def edit
  	activate_account_user(params[:id])
  end
  
  def activate_account_user(token)
  	[token, user_id] = token_id.split('.', 2)
  	if @user = User.find_by!(id: user_id, confirm_token: token)
	  return @user
	end
	redirect_to new_user_path, alert: "User indicated in link does not exist or email confirmation token does not match."
	return false
  end
end