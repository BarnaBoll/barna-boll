class CreateRegistrationMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :registration_members do |t|
      t.references :registration, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    # Remove the old JSONB column
    remove_column :registrations, :present_member_ids, :jsonb
  end
end
