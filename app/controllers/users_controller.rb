class UsersController < ApplicationController

  load_and_authorize_resource

  before_action :set_user, except: [:follow, :unfollow]
  before_action :network, only: [:followers, :followings, :blocked]
  
  def show
    @favorite_artists = @user.favorite_artists.map(&:artist)
    @registers = @user.registers.order(created_at: :desc)
    @registers_with_review = @registers.where.not(review: nil).where("TRIM(review) != ''")
    @populars_registers = @user.registers.left_joins(:likes).group(:id).order("COUNT(likes.id) DESC")
    @future_assistances = @user.future_assistances.order(created_at: :desc)
    @publications = @user.publications.order(created_at: :desc)
    @populars_publications = @user.publications.left_joins(:likes).group(:id).order("COUNT(likes.id) DESC")
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
    @registers = @user.registers.joins(:event).order("events.date DESC")
  end

  def artists
    @favorites = @user.favorite_artists.map(&:artist)
    @artists = @user.followings.artists.map(&:followed).reject { |artist| @favorites.map(&:id).include?(artist.id) }
  end

  def requests
    @requests = Request.where(requester_id: @user.id).order("created_at DESC")
  end

  def future_assistances
    @future_assistances = @user.future_assistances.joins(:event).order("events.date ASC")
  end

  def publications
    @publications = @user.publications.order("created_at DESC")
  end

  def network
    @followings = @user.followings.users.users.map(&:followed)
    @followers = @user.followers.users.map(&:follower)
    @blocked = @user.blocked_users.users.map(&:followed)
  end
  
  def followings
  end

  def followers
  end

  def blocked
  end

  def follow
    current_user.follow(params[:id])
    redirect_back fallback_location: root_path
  end

  def unfollow
    params[:follower_id] ? User.find(params[:follower_id]).unfollow(current_user.id) : current_user.unfollow(params[:id])
    redirect_back fallback_location: root_path
  end

  def block
    @user.block(current_user&.id)
    redirect_back fallback_location: root_path
  end

  def unblock
    @user.unblock(current_user&.id)
    redirect_back fallback_location: root_path
  end
  
private

  def set_user
    @user = User.viewables(current_user).find_by(id: params[:id])
    #TO/DO mostrar error de q no encontró al usuario o whatever, de "ha ocurrido un error", se ve muy bien entrando en un like o comentario pasado del usuario q te ha bloqueado
    if !@user
      redirect_back fallback_location: root_path
    end
  end

  def create_params
      params.require(:user).permit(:username, :email, :description, :icon)
  end 

end
