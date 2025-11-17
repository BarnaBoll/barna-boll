# config/initializers/devise_auto_sign_in.rb
Rails.application.config.after_initialize do
  Devise::ConfirmationsController.class_eval do
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        set_flash_message!(:notice, :confirmed)

        # Debug logging
        Rails.logger.info "🎯 AUTO SIGN-IN PATCH: Confirming user #{resource.email}"

        # Force sign in after confirmation
        sign_in(resource)
        Rails.logger.info "🎯 AUTO SIGN-IN PATCH: User signed in: #{user_signed_in?}"

        respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
      else
        respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
      end
    end

    protected

    def after_confirmation_path_for(resource_name, resource)
      Rails.logger.info "🎯 AFTER_CONFIRMATION_PATH_FOR CALLED IN PATCH"
      authenticated_root_path
    end
  end
end
