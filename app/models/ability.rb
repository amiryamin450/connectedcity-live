class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    else
      can :read, :all

      can [:claim, :claim_process], Location do |l|
        user.persisted?
      end

      can :manage, ClassifiedListing, user_id: user.id

      can :manage, BusinessImprovementArea, user_id: user.id

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

      can :manage, NewHomeCommunity do |new_home_community|
        can? :manage, new_home_community.location
      end

      can :manage, NewHome do |new_home|
        can? :manage, new_home.new_home_community
      end

      can :manage, AutomotiveListing do |automotive_listing|
        can? :manage, automotive_listing.location
      end

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

      cannot :read, SocialProfile do |social_profile|
        cannot? :manage, social_profile.owner
      end

      can :manage, SocialProfile do |social_profile|
        can? :manage, social_profile.owner
      end
    end
  end
end
