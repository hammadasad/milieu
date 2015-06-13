class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to root_path, notice: "Successfully registered."
		else
			flash.now[:alert] = "Whoops, something went wrong! Try again!"
			render :new
		end
	end

	def edit
		
	end

	def update
		
	end

	def destroy
		
	end

	private
		def user_params
			params.require(:user).permit(:fname,:lname,:user_name,:email,:password,:password_confirmation)
		end
end
