class UsersController < ApplicationController
  before_action :signed_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :not_signed_in_user, only: [:new, :create]

  def index
  	@users = User.paginate(page: params[:page])
  end
  
  def show
  	@user = User.find(params[:id])
  	@microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
	  sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
  	# we already checked if user is admin with before_action
  	# now we have to stop an admin deleting herself
	user = User.find(params[:id])
	if current_user?(user)
	  redirect_to root_url, alert: "Sorry, admin. You just can't delete yourself like that!"
	else
	  user.destroy
	  flash[:success] = "User deleted."
	  redirect_to users_url
  	end
  end
  
  def following
	@user = User.find(params[:id])
	@users = @user.followed_users.paginate(page: params[:page])
	@title = "Following #{@user.name}"
	render 'show_follow'
  end
  
  def followers
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
  	@title = "#{@user.name} Followers"
    render 'show_follow'
  end

  private
  
	def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # before filters
    
    def correct_user
	  @user = User.find(params[:id])    # moved here from edit/update methods
	  redirect_to root_url unless current_user?(@user)
	end
	
	def admin_user
	  redirect_to root_url unless current_user.admin?
	end
	
	def not_signed_in_user
	  redirect_to root_url if signed_in?
	end

end
