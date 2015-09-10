class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    else
      can :read, :all
      can :manage, ClassifiedListing, user_id: user.id

      can :manage, Location do |location|
        location.user_can_manage?(user)
      end

      can :manage, Manager, location: { id: user.location_ids }

      can :manage, LocationImage do |location_image|
        can? :manage, location_image.location
      end

      can :manage, BlogEntry do |blog|
        can? :manage, blog.bloggable
      end

      can :manage, NewsArticle do |article|
        can? :manage, article.newsable
      end

      can :manage, MediaAttachment do |media_attachment|
        can? :manage, media_attachment.attachable
      end

      can :manage, StatusUpdate do |status_update|
        can? :manage, status_update.statusable
      end

      can :manage, AutomotiveListing, location: { user_id: user.id }

      can :manage, Product do |product|
        can? :manage, product.location
      end

      can :manage, Coupon do |coupon|
        can? :manage, coupon.location
      end

      can :manage, Service do |service|
        can? :manage, service.location
      end

      can :manage, Event do |event|
        can? :manage, event.location
      end

      can :manage, EmploymentListing do |employment_listing|
        can? :manage, employment_listing.location
      end
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
