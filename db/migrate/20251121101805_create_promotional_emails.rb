class CreatePromotionalEmails < ActiveRecord::Migration[8.1]
  def change
    create_table :promotional_emails do |t|
      t.string   :title,   null: false
      t.string   :subject, null: false
      t.text     :intro
      t.text     :body
      t.string   :cta_label
      t.string   :cta_url
      t.datetime :send_at
      t.datetime :sent_at

      t.timestamps
    end
  end
end
