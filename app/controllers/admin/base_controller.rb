# app/controllers/admin/base_controller.rb
module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    layout "application"

    private

    def require_admin!
      return if current_user&.admin?

      redirect_to authenticated_root_path,
                  alert: "You do not have permission to access the admin area."
    end
  end
end
