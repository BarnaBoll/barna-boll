# app/controllers/admin/users_controller.rb
module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[show edit update destroy toggle_admin]

    def index
      @users = User.order(created_at: :desc)
    end

    def show; end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params_for_create)

      if @user.save
        redirect_to admin_user_path(@user), notice: "User created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @user.update(user_params_for_update)
        redirect_to admin_user_path(@user), notice: "User updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: "User deleted."
    end

    # One-click toggle for admin flag
    def toggle_admin
      @user.update!(admin: !@user.admin?)
      redirect_to admin_user_path(@user), notice: "Admin set to #{@user.admin?}."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    # Strong params
    def user_params_for_create
      params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
    end

    def user_params_for_update
      # Email/name/admin; password fields are optional on update
      params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
    end
  end
end
