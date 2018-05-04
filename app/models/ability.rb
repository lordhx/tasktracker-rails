class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    user ||= User.new # guest user (not logged in)

    if user.manager?
      can :read, Issue
      can :assign, Issue
    elsif user.regular?
      can :crud, Issue, author_id: user.id
    end
  end
end
