class Notifier < ActionMailer::Base
  default from: "from@example.com"

  def follower_notification(user, follower)
	@user = user
	@follower = follower
	mail(:to => user_to(user), :subject => "#{follower.name} is following you")
  end
  
  def confirm_email(user)
    @user = user
    mail(to: user_to(user), subject: "Please confirm your email address")
  end
  
  def signup_confirmation(user)
    @user = user
    mail(:to => user_to(user), :subject => "Registered")
  end
  
  def password_reset(user)
  	@user = user
    mail(:to => user_to(user), :subject => "Password Reset")
  end

  private
	def user_to(user)
	  "#{user.name} <#{user.email}>"
	end
end
