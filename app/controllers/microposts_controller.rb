class MicropostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy
	
	def create
	  @micropost = current_user.microposts.build(micropost_params)
	  # look for an @username replies
	  replies_to = @micropost.content.scan(/@[0-9A-Za-z_]+/)
	  # init array to avoid nilClass error when invalid micropost submitted
	  @feed_items = []
	  if @micropost.save
	  	@micropost.reply_to(replies_to) if (replies_to.any?)
	  	redirect_to root_url, flash: { success: "Micropost created!" }
	  else
	  	render 'static_pages/home'
	  end
	end
	
	def destroy
	  @micropost.destroy
	  redirect_to root_url, flash: { notice: "Micropost deleted!" }
	end
	
	private
	  def micropost_params
	  	params.require(:micropost).permit(:content)
	  end
	  
	  def correct_user
	  	@micropost = current_user.microposts.find_by(id: params[:id])
	  rescue
		  redirect_to root_url, flash: { notice: "Micropost not found" }
	  end
end