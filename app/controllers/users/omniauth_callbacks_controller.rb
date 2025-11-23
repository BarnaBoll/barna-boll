# app/controllers/users/omniauth_callbacks_controller.rb
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # Google callback
    def google_oauth2
      handle_auth "Google"
    end

    # Facebook callback
    def facebook
      handle_auth "Facebook"
    end

    def failure
      redirect_to root_path, alert: "Det gick inte att logga in. Försök igen."
    end

    private

    def handle_auth(kind)
      auth = request.env["omniauth.auth"]

      Rails.logger.info "OmniAuth #{kind} callback: #{auth&.inspect}"

      @user = User.from_omniauth(auth)

      if @user.persisted?
        set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
        sign_in_and_redirect @user, event: :authentication
      else
        session["devise.#{kind.downcase}_data"] = auth.except("extra") if auth.present?
        redirect_to new_user_registration_url,
                    alert: "Det gick inte att skapa ett konto via #{kind}."
      end
    end
  end
end
