# app/models/promotional_email.rb
class PromotionalEmail < ApplicationRecord
  validates :title, :subject, presence: true

  # When created/updated, schedule a future blast if send_at is in the future
  after_commit :schedule_future_delivery, on: %i[create update]

  private

  def schedule_future_delivery
    return if sent_at.present?
    return unless send_at.present? && send_at.future?

    changed_send_at =
      if respond_to?(:saved_change_to_send_at?)
        saved_change_to_send_at?
      else
        previous_changes.key?("send_at")
      end

    return unless changed_send_at || (respond_to?(:previously_new_record?) ? previously_new_record? : created_at == updated_at)

    PromotionalEmailBlastJob.set(wait_until: send_at).perform_later(id)
  end
end
