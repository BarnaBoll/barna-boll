# app/controllers/admin/dashboard_controller.rb
module Admin
  class DashboardController < BaseController
    def index
      @users_count   = User.count
      @admins_count  = User.admins.count
      @recent_users  = User.order(created_at: :desc).limit(5)
    end

    def show
      # Optional: can be used later for detailed reports / stats
    end
  end
end
