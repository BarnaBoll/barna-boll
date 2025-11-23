# app/mailers/promotional_email_mailer.rb
class PromotionalEmailMailer < ApplicationMailer
  def promotional_email(promotional_email_id, user_id)
    @promotional_email = PromotionalEmail.find(promotional_email_id)
    @user              = User.find(user_id)

    mail(
      to: @user.email,
      subject: @promotional_email.subject
    )
  end
end
