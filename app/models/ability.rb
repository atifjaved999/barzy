class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      if user.is?("Super Admin")
        can :manage, :all
      elsif user.is?("Admin")
        can :read, [Admin]
        can [:show, :edit, :update], Bar do |bar|
          bar.users.try(:ids).include?(user.id)
        end
        can [:show, :edit, :update], Menu do |menu|
           user.bars.try(:ids).include?(menu.bar.id)
        end
        can :manage, ProductCategory
        # can :read, :all
      end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
