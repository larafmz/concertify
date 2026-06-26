class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def edit
      @user = User.find(params[:id])
  end

  
  def update
    @user = User.find(params[:id])
    Ubication.find_or_create_by!(user_id: params[:id]) do |u|
      u.country = Country.find_by(code: params[:country])
      u.city = params[:city]
    end

    if @user.update(create_params)
      redirect_to user_path(@user.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
private

  def create_params
      params.require(:user).permit(:username, :name, :email, :description)
  end 

end
