class Notifier < ActionMailer::Base
  default from: "from@example.com"

  def follower_notification(user, follower)
	@user = user
	@follower = follower
	mail(:to => "#{user.name} <#{user.email}>", :subject => "#{follower.name} is following you")
  end
  
  def confirm_email(user)
    @user = user
    mail(to: "#{user.name} <#{user.email}>", subject: "Please confirm your email address")
  end
  
  def signup_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end
  
  def password_reset(user)
  	@user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Password Reset")
  end
end
