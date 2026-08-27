class UsersController < ApplicationController

  load_and_authorize_resource except: [:show]

  before_action :set_user, except: [:follow, :unfollow, :index]
  before_action :network, only: [:followers, :followings, :blocked]

  def index
    @users = User.viewables(current_user).by_name(params[:search] )
  end

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
    @requests = Request.do_search(params, user: @user)
  end

  def future_assistances
    @future_assistances = @user.future_assistances.joins(:event).order("events.date ASC")
  end

  def publications
    @publications = @user.publications.order("created_at DESC")
  end

  def notifications
    @notifications = @user.notifications.order(created_at: :desc)
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
    current_user.block(@user.id) if @user.user?
    redirect_back fallback_location: root_path
  end

  def unblock
    @user.unblock(current_user&.id)
    redirect_back fallback_location: root_path
  end
  
private

  def network
    @followings = @user.followings.users.users.map(&:followed)
    @followers = @user.followers.users.map(&:follower)
    @blocked = @user.blocked_users.users.map(&:followed)
  end

  def set_user
    @user = User.find(params[:id])
    unless @user
      flash[:alert] = t("not_found_masc", model: User.singular.downcase)
      redirect_back fallback_location: root_path
      return
    end
  end

  def create_params
      params.require(:user).permit(:username, :email, :description, :icon)
  end 

end
