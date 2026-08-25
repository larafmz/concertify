# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user.present?

      can :manage, :all
 
      if user.user?
 
        cannot :edit, Request do |request| request.requester_id != user.id || request.status !=  1 end
        cannot :requests, User do |other_user| other_user.id != user.id end
        cannot :read, Request 

      elsif user.admin?

        can :manage, :all

      end

    else

      # non registered user
      #TO/DO cant do anything by now 

    end


    # here are :read, :create, :update and :destroy.
    # For example, here the user can only update published articles.
    #   can :update, Article, published: true
    
  end

end
