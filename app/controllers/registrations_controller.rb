class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    # Only allow guest or host roles from signup (not admin)
    @user.role = :guest unless @user.role.in?(%w[guest host])

    if @user.save
      session[:user_id] = @user.id
      role_message = @user.host? ? "You can now create and manage events!" : "You can now RSVP to events!"
      redirect_to root_path, notice: "Welcome! You have signed up successfully. #{role_message}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, :role)
  end
end
