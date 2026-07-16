class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    if @user
      @favorite_artists = @user.favorite_artists.map(&:artist)
      @registers = @user.registered_concerts.order(created_at: :desc)
      @registers_with_review = @registers.where.not(review: nil).where("TRIM(review) != ''")
      @future_assistances = @user.future_assistances.order(created_at: :desc)
    end
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

  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.users.users.map(&:followed)
    @followers = @user.followers.users.map(&:follower)
  end

  def followers
    @user = User.find(params[:id])
    @followings = @user.followings.users.map(&:followed)
    @followers = @user.followers.users.map(&:follower)
  end

  def follow
    if params[:follower_id]
      User.find(params[:follower_id]).follow(current_user.id) 
    else
      current_user.follow(params[:id])
    end
    redirect_back fallback_location: root_path
  end

  def unfollow
    current_user.unfollow(params[:id])
    redirect_back fallback_location: root_path
  end

  def block
    User.find(params[:id]).block(current_user.id)
    redirect_back fallback_location: root_path
  end

  def unblock
    User.find(params[:id]).unblock(current_user.id)
    redirect_back fallback_location: root_path
  end
  
private

  def create_params
      params.require(:user).permit(:username, :email, :description, :icon)
  end 

end
