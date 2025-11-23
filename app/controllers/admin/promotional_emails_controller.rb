# app/controllers/admin/promotional_emails_controller.rb
module Admin
  class PromotionalEmailsController < BaseController
    before_action :set_promotional_email, only: %i[show edit update destroy send_now]

    def index
      @promotional_emails = PromotionalEmail.order(created_at: :desc)
    end

    def show; end

    def new
      @promotional_email = PromotionalEmail.new
    end

    def create
      @promotional_email = PromotionalEmail.new(promotional_email_params)

      if @promotional_email.save
        if params[:send_now] == "1"
          PromotionalEmailBlastJob.perform_later(@promotional_email.id)
          flash[:notice] = "Utskicket skickas nu till alla verifierade användare."
        elsif @promotional_email.send_at.present?
          flash[:notice] = "Utskicket har sparats och kommer att skickas vid #{I18n.l(@promotional_email.send_at, format: :long) rescue @promotional_email.send_at}."
        else
          flash[:notice] = "Utskicket har sparats som utkast."
        end

        redirect_to admin_promotional_email_path(@promotional_email)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @promotional_email.update(promotional_email_params)
        if @promotional_email.send_at.present? && @promotional_email.sent_at.blank?
          flash[:notice] = "Utskicket har uppdaterats. Det kommer skickas vid #{I18n.l(@promotional_email.send_at, format: :long) rescue @promotional_email.send_at}."
        else
          flash[:notice] = "Utskicket har uppdaterats."
        end

        redirect_to admin_promotional_email_path(@promotional_email)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @promotional_email.destroy
      redirect_to admin_promotional_emails_path, notice: "Utskicket har raderats."
    end

    # POST /admin/promotional_emails/:id/send_now
    def send_now
      PromotionalEmailBlastJob.perform_later(@promotional_email.id)
      redirect_to admin_promotional_email_path(@promotional_email),
                  notice: "Utskicket skickas nu till alla verifierade användare."
    end

    private

    def set_promotional_email
      @promotional_email = PromotionalEmail.find(params[:id])
    end

    def promotional_email_params
      params.require(:promotional_email).permit(
        :title,
        :subject,
        :intro,
        :body,
        :cta_label,
        :cta_url,
        :send_at
      )
    end
  end
end
