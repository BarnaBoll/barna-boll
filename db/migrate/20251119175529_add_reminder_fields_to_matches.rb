class AddReminderFieldsToMatches < ActiveRecord::Migration[8.1]
  def change
    add_column :matches, :reminder_offset_minutes, :integer
    add_column :matches, :reminder_sent_at, :datetime
  end
end
