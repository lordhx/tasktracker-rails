class ApplicationController < ActionController::API
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    # I would prefer to reply with not_found
    # so the user that tried to access these data would not have any idea that they exist
    head :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    head :not_found
  end
end
