module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
	gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
	size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  def find_user(p)
  	if (p[:id].any?)
	  User.find(p[:id])
	elsif (p[:email].any?)
	  User.find_by(email: p[:email])
	elsif (p[:username].any?)
	  User.find_by(username: p[:username])
	end
  end
end
