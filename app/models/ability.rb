class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    else
      can :read, :all
      can :manage, ClassifiedListing, user_id: user.id

      can :manage, Location, user_id: user.id, claim_pending: false

      can :manage, LocationImage do |location_image|
        can? :manage, location_image.location
      end

      can :manage, BlogEntry do |blog|
        blog.bloggable.user_id == user.id
      end

      can :manage, NewsArticle do |article|
        article.newsable.user_id == user.id
      end

      can :manage, MediaAttachment do |media_attachment|
        media_attachment.attachable.user_id == user.id
      end

      can :manage, StatusUpdate do |status_update|
        can? :manage, status_update.statusable
      end

      can :manage, AutomotiveListing, location: { user_id: user.id }
      can :manage, Product, location: { user_id: user.id }
      can :manage, Coupon, location: { user_id: user.id }
      can :manage, Service, location: { user_id: user.id }
      can :manage, Event, location: { user_id: user.id }
      can :manage, EmploymentListing, location: { user_id: user.id }

    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
