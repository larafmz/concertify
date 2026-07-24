class UsersController < ApplicationController

  before_action :set_user, except: [:follow, :unfollow]
  
  def show
    @favorite_artists = @user.favorite_artists.map(&:artist)
    @registers = @user.registers.order(created_at: :desc)
    @registers_with_review = @registers.where.not(review: nil).where("TRIM(review) != ''")
    @populars_registers = @user.registers.left_joins(:likes).group(:id).order("COUNT(likes.id) DESC")
    @future_assistances = @user.future_assistances.order(created_at: :desc)
  end

  def edit
  end

  def update
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

  def registers
    @registers = @user.registers.order("created_at DESC")
  end

  def diary
    @registers = @user.registers.joins(:concert).order("concerts.date DESC")
  end

  def artists
    @favorites = @user.favorite_artists.map(&:artist)
    @artists = @user.followings.artists.map(&:followed).reject { |artist| @favorites.map(&:id).include?(artist.id) }
  end

  def requests
    @requests = Concert.where(requester_id: @user.id).order("created_at DESC")
  end

  def future_assistances
    @future_assistances = @user.future_assistances.joins(:concert).order("concerts.date ASC")
  end

  def publications
    @publications = @user.publications.order("created_at DESC")
  end

  def followings
    @followings = @user.followings.users.users.map(&:followed)
    @followers = @user.followers.users.map(&:follower)
  end

  def followers
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
    @user.block(current_user.id)
    redirect_back fallback_location: root_path
  end

  def unblock
    @user.unblock(current_user.id)
    redirect_back fallback_location: root_path
  end
  
private

  def set_user
    @user = User.find(params[:id])
  end

  def create_params
      params.require(:user).permit(:username, :email, :description, :icon)
  end 

end
