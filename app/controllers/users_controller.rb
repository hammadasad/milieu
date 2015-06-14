class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	user = User.new(user_params)
    if user.save
      redirect_to root_path, :notice => "Signed Up!"
    else
      flash.now[:alert] = 'Couldn\'t sign up, try again and submit!'
      render :new
    end
  end

  private
	  def user_params
	    params.require(:user).permit(:fname,:lname,:user_name,:email,:password,:password_confirmation)
	  end
end
