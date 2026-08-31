class UsersController < ApplicationController

  load_and_authorize_resource

  before_action :network, only: [:followers, :followings, :blocked]

  def index
    users = User.viewables(current_user).by_name(params[:search] )
    @users = users.page(params[:page]).per(20)
    @pagination_path = request.query_parameters.merge(controller: "users",action: "index")
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
 
  def show
    @favorite_artists = @user.favorite_artists.map(&:artist)
    @registers = @user.registers.order(created_at: :desc).limit(4)
    @registers_with_review = @registers.where.not(review: nil).where("TRIM(review) != ''").limit(2)
    @populars_registers = @user.registers.left_joins(:likes).group(:id).order("COUNT(likes.id) DESC").limit(2)
    @future_assistances = @user.future_assistances.order(created_at: :desc).limit(5)
    @publications = @user.publications.order(created_at: :desc).limit(3); 
    @populars_publications = @user.publications.left_joins(:likes).group(:id).order("COUNT(likes.id) DESC").limit(3); 
  end

  def edit
  end

  def update
    @user.icon.purge if params[:remove_icon] == "1" && @user.icon.attached?

    if @user.update(create_params)
      redirect_to user_path(@user.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def registers
    registers = @user.registers.order("created_at DESC")
    @registers = registers.page(params[:page]).per(5)
    @pagination_path = { controller: "users", action: "registers", user_id: @user.id }
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def diary
    registers = @user.registers.joins(:event).order("events.date DESC")
    @registers = registers.page(params[:page]).per(10)
    @pagination_path = { controller: "users", action: "diary", user_id: @user.id }
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def artists
    favorites = @user.favorite_artists.map(&:artist)
    artists = @user.followings.artists.map(&:followed).reject { |artist| favorites.map(&:id).include?(artist.id) }
    @artists = Kaminari.paginate_array(favorites + artists).page(params[:page]).per(32)
  end

  def requests
    @requests = Request.do_search(params, user: @user)
  end

  def future_assistances
    future_assistances = @user.future_assistances.joins(:event).includes( event: [ :artists, :ubication, { photo_attachment: :blob }]).order("events.date ASC")
    @future_assistances = future_assistances.page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def publications
    @publications = @user.publications.order("created_at DESC")
    @publications = @publications.page(params[:page]).per(10)
    @pagination_path = { controller: "users", action: "publications", user_id: @user.id }
    respond_to do |format|
        format.html
        format.turbo_stream
    end
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
    current_user.follow(@user)
    respond_to do |format|
       format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "follow-user-#{@user.id}",
            partial: "users/relation_buttons",
            locals: { user: @user }
          )
        end
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def unfollow
    params[:follower_id] ? User.find(params[:follower_id]).unfollow(current_user) : current_user.unfollow(@user)
    respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "follow-user-#{@user.id}",
            partial: "users/relation_buttons",
            locals: { user: @user }
          )
        end
      format.html { redirect_back fallback_location: root_path }
    end
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
    @followings = User.viewables(current_user).where(id: @user.followings.users.select(:followed_id))
    @followers = User.viewables(current_user).where(id: @user.followers.users.select(:follower_id))
    @blocked = @user.blocked_users.users.map(&:followed)
  end

  def create_params
      params.require(:user).permit(:username, :email, :description, :icon, ubication_attributes: [:id, :city, :country_id])
  end 

end
