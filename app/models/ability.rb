# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user.present?

      can :manage, :all
 
      if user.user?
 
        cannot :edit, Event do |event| event.requester_id != user.id || event.status !=  1 end
        cannot :requests, User do |other_user| other_user.id != user.id end

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
