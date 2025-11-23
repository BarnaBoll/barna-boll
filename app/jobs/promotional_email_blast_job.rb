# app/jobs/promotional_email_blast_job.rb
class PromotionalEmailBlastJob < ApplicationJob
  queue_as :default

  def perform(promotional_email_id)
    promo = PromotionalEmail.find(promotional_email_id)

    # Don’t send twice
    return if promo.sent_at.present?

    recipients = User.where.not(confirmed_at: nil)

    recipients.find_each do |user|
      PromotionalEmailMailer.promotional_email(promo.id, user.id).deliver_later
    end

    promo.update!(sent_at: Time.current)
  end
end
