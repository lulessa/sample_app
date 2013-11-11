ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "sampleapp.example.com",
  :user_name            => "thelukas@gmail.com",
  :password             => 'dkgbadlytqnkwsap',
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
