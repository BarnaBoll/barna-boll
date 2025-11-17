# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # GET /profile
  def show
  end

  # PATCH /profile
  def update
    if @user.update(profile_params)
      flash[:notice] = "Dina ändringar har sparats."
      redirect_to profile_path
    else
      render :show, status: :unprocessable_entity
    end
  end

  # POST /profile/update_password
  def update_password
    # Devise built-in secure password change method:
    # requires current_password, password, password_confirmation
    if @user.update_with_password(password_params)
      # Keep the user signed in after password change
      bypass_sign_in(@user)

      flash[:notice] = "Lösenordet har uppdaterats."
      redirect_to profile_path
    else
      # Validation errors (wrong current password, mismatch, etc.)
      # Re-render the profile page with @user.errors populated
      render :show, status: :unprocessable_entity
    end
  end

  # DELETE /profile
  def destroy
    @user.destroy!
    reset_session
    flash[:notice] = "Ditt konto har raderats permanent."
    redirect_to root_path
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    params.require(:user).permit(:name)
  end

  # MUST include :current_password for update_with_password
  def password_params
    params.require(:user)
          .permit(:current_password, :password, :password_confirmation)
  end
end
