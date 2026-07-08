class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def edit
      @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    ubication = Ubication.find_or_initialize_by(user_id: @user.id)
    ubication.country = Country.find_by(code: params[:country])
    ubication.city = params[:city]
    ubication.save!

    @user.icon.purge if params[:remove_icon] == "1" && @user.icon.attached?

    if @user.update(create_params)
      redirect_to user_path(@user.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
private

  def create_params
      params.require(:user).permit(:username, :name, :email, :description, :icon)
  end 

end
