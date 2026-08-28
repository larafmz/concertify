# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    
    # read permissions
    can :read, [Register, Interactuable, Comment, Publication]
    can :read, [Artist] do |artist| artist.accepted? end
    can [:followers, :publications, :registers], [Artist] do |artist| artist.accepted? end
    can [:read, :registers, :future_assistances, :publications, :artists], Event do |event| event.accepted? end
    can [:reposts, :comments], Interactuable
    
    if user.present?

      if user.admin?

        can :manage, :all
 
      elsif user.user?

        #read permissions

        # update and create permissions
        can [:update, :destroy], [Register, Interactuable, FutureAssistance], user_id: user.id
        can :create, [Register, Interactuable, FutureAssistance, Publication, Request]

        # Chat permissions
        can [:read, :exit, :mark_as_read], Chat do |chat| 
          chat.chat_users.exists?(user_id: user.id)
        end

        can :send_message, Chat do |chat|
          chat.chat_users.exists?(user_id: user.id) &&
            (
              chat.group_chat? ||
              (
                !chat.other_user(user).blocked_user?(user.id) &&
                !user.blocked_user?(chat.other_user(user).id)
              )
            )
        end
        
        # Interactuable permissions
        can [:like, :repost, :comment], Interactuable do |interactuable| 
          interactuable.user_id != user.id && !interactuable.user.blocked_user?(user.id) && !user.blocked_user?(interactuable.user.id)
        end
        can [:uncomment], Interactuable, user_id: user.id
        can [:reply], Comment do |comment| 
          !comment.interactuable.user.blocked_user?(user.id) && !user.blocked_user?(comment.interactuable.user.id)
        end
        can [:destroy], Comment do |comment| comment.user_id == user.id || comment.interactuable.user_id == user.id end

        # Artist/Event permissions
        can [:post, :follow, :unfollow, :mark_as_favorite, :unmark_as_favorite], Artist do |artist| artist.accepted? end
        can [:post], Event do |event| event.accepted? end

        # User permissions
        can :read, User do |target| !target.blocked_user?(user.id) end
        can [:update, :blocked, :requests, :notifications], User, id: user.id
        can [:follow, :unfollow], User do |target|
          target.id != user.id && !target.blocked_user?(user.id)
        end
        can [:block, :unblock], User do |target|
          target.id != user.id && !target.admin? && !target.blocked_user?(user.id)
        end
        can [:followers, :followings, :registers, :diary, :future_assistances, :publications, :artists], User do |target| 
          !target.blocked_user?(user.id) 
        end
        
        # Requests permissions
        can [:edit, :destroy], Request do |request| request.requester_id == user.id && request.status ==  Request::STATUS_PENDING end
        
        # Notifications permissions
        can [:mark_as_read, :read_and_redirect, :mark_all_read], Notification do |notification| notification.recipient == user end

      end

    else
        # can read ALL users
        can :read, User
        can [:followers, :followings, :registers, :diary, :future_assistances, :publications, :artists], User
    end

  end

end
